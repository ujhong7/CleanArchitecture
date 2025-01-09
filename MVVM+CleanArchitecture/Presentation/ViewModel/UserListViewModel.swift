//
//  UserListViewModel.swift
//  MVVM+CleanArchitecture
//
//  Created by yujaehong on 1/8/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserListViewModelProtocol {
    func transform(input: UserListViewModel.Input) -> UserListViewModel.Output
}

public final class UserListViewModel: UserListViewModelProtocol {
    
    private let usecase: UserListUsecaseProtocol
    private let disposeBag = DisposeBag()
    private let error = PublishRelay<String>()
    private let fetchUserList = BehaviorRelay<[UserListItem]>(value: [])
    private let allFavoriteUserList = BehaviorRelay<[UserListItem]>(value: []) // 즐겨찾기 여부를 위한 전체목록
    private let favoriteUserList = BehaviorRelay<[UserListItem]>(value: []) // 목록에 보여줄 리스트
    private var page: Int = 1
    
    public init(usecase: UserListUsecaseProtocol) {
        self.usecase = usecase
    }
    
    // 이벤트 (VC) -> 가공 or 외부에서 데이터 호출 or 뷰데이터를 전달 (VM) -> VC
    
    public struct Input { // VM 에게 전달되어야 할 이벤트
        let tabButtonType: Observable<TabButtonType>
        let query: Observable<String>
        let saveFavorite: Observable<UserListItem>
        let deleteFavorite: Observable<Int>
        let fetchMore: Observable<Void>
    }
    
    public struct Output { // VC 에게 전달할 뷰 데이터
        let cellData: Observable<[UserListCellData]>
        let error: Observable<String>
    }
    
    public func transform(input: Input) -> Output { // VC 이벤트 -> VM 데이터
        
        input.query.bind { [weak self] query in
            // user Fetch and get favorite Users
            guard let self = self, validateQuery(query: query) else {
                self?.getFavoriteUsers(query: "")
                return
            }
            page = 1
            fetchUser(query: query, page: page)
            getFavoriteUsers(query: query)
        }.disposed(by: disposeBag)
        
        input.saveFavorite
            .withLatestFrom(input.query, resultSelector: { users, query in
                return (users, query)
            })
            .bind { [weak self] user, query in
                // 즐겨찾기 추가
                self?.saveFavoriteUser(user: user, query: query)
            }.disposed(by: disposeBag)
        
        input.deleteFavorite
            .withLatestFrom(input.query, resultSelector: { users, query in
                return (users, query)
            })
            .bind { userID, query in
                // 즐겨찾기 삭제
                self.deleteFavoriteUser(userID: userID, query: query)
            }.disposed(by: disposeBag)
        
        input.fetchMore
            .withLatestFrom(input.query)
            .bind { [weak self] query in
                // 다음 페이지 검색
                guard let self = self else { return }
                page += 1
                fetchUser(query: query, page: page)
            }.disposed(by: disposeBag)
        
        // 유저리스트 탭, 즐겨찾기 탭
        let cellData: Observable<[UserListCellData]> = Observable.combineLatest(input.tabButtonType, fetchUserList, favoriteUserList, allFavoriteUserList)
            .map { [weak self] tabButtonType, fetchUserList, favoriteUserList, allFavoriteUserList in
                
                var cellData: [UserListCellData] = []
                // celldata 생성
                guard let self = self else { return cellData }
                switch tabButtonType {
                case .api:
                    // Tab 타입에 따라 fetchUser List
                    let tuple = usecase.checkFavoriteState(fetchUsers: fetchUserList, favoriteUsers: allFavoriteUserList)
                    let userCellList = tuple.map { user, isFavorite in
                        UserListCellData.user(user: user, isFavorite: isFavorite)
                    }
                    return userCellList
                case .favorite:
                    // Tab 타입에 따라 favoriteUser List
                    let dict = usecase.convertListToDictionary(favoriteUsers: favoriteUserList)
                    let keys = dict.keys.sorted() // key : [User list]
                    keys.forEach { key in
                        cellData.append(.header(key))
                        if let users = dict[key] {
                            let userListCell = users.map { user in
                                UserListCellData.user(user: user, isFavorite: true)
                            }
                            cellData += userListCell
                        }
                    }
                }
                return cellData
            }
        
        return Output(cellData: cellData, error: error.asObservable())
    }
    
    private func fetchUser(query: String, page: Int) {
        guard let urlAllowedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        Task {
            let result = await usecase.fetchUser(query: urlAllowedQuery, page: page)
            switch result {
            case .success(let users):
                if page == 0 {
                    fetchUserList.accept(users.items)
                } else {
                    fetchUserList.accept(fetchUserList.value + users.items)
                }
            case .failure(let error):
                self.error.accept(error.description)
            }
        }
    }
    
    private func getFavoriteUsers(query: String) {
        let result = usecase.getFavoriteUsers()
        switch result {
        case .success(let users):
            // 검색어가 있을때 필터링
            if query.isEmpty {
                favoriteUserList.accept(users)
            } else {
                let filterdUsers = users.filter { user in
                    user.login.contains(query)
                }
                favoriteUserList.accept(filterdUsers)
            }
            
            // 전체 목록
            allFavoriteUserList.accept(users)
            
        case . failure(let error):
            self.error.accept(error.description)
        }
    }
    
    private func saveFavoriteUser(user: UserListItem, query: String) {
        let result = usecase.saveFavoriteUser(user: user)
        switch result {
        case .success:
            getFavoriteUsers(query: query)
        case .failure(let error):
            self.error.accept(error.description)
        }
    }
    
    private func deleteFavoriteUser(userID: Int, query: String) {
        let result = usecase.deleteFavoriteUser(userID: userID)
        switch result {
        case .success:
            getFavoriteUsers(query: query)
        case .failure(let error):
            self.error.accept(error.description)
        }
    }
    
    private func validateQuery(query: String) -> Bool {
        if query.isEmpty {
            return false
        } else {
            return true
        }
    }
    
}

public enum TabButtonType: String {
    case api = "API"
    case favorite = "Favorite"
}

public enum UserListCellData {
    case user(user: UserListItem, isFavorite: Bool)
    case header(String)
}
