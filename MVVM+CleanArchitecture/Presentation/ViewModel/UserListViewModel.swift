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
    
}

public final class UserListViewModel: UserListViewModelProtocol {
    
    private let usecase: UserListUsecaseProtocol
    private let disposeBag = DisposeBag()
    private let error = PublishRelay<String>()
    private let fetchUserList = BehaviorRelay<[UserListItem]>(value: [])
    private let allFavoriteUserList = BehaviorRelay<[UserListItem]>(value: []) // 즐겨찾기 여부를 위한 전체목록
    private let favoriteUserList = BehaviorRelay<[UserListItem]>(value: []) // 목록에 보여줄 리스트
    
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
            guard let isValidate = self?.validateQuery(query: query), isValidate else {
                self?.getFavoriteUsers(query: "")
                return
            }
            self?.fetchUser(query: query, page: 0)
            self?.getFavoriteUsers(query: query)
        }.disposed(by: disposeBag)
        
        input.saveFavorite.bind { user in
            // TODO: 즐겨찾기 추가
        }.disposed(by: disposeBag)
        
        input.deleteFavorite.bind { userID in
            // TODO: 즐겨찾기 삭제
        }.disposed(by: disposeBag)
        
        input.fetchMore.bind {
            // TODO: 다음 페이지 검색
        }.disposed(by: disposeBag)
        
        // 유저리스트 탭, 즐겨찾기 탭
        let cellData: Observable<[UserListCellData]> = Observable.combineLatest(input.tabButtonType, fetchUserList, favoriteUserList).map { tabButtonType, fetchUserList, favoriteUserList in
            let cellData: [UserListCellData] = []
            // TODO: celldata 생성
            return cellData
        }
        
        return Output(cellData: cellData, error: error.asObservable())
    }
    
    private func fetchUser(query: String, page: Int) {
        guard let urlAllowedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        Task {
            let result = await usecase.fetchUser(query: query, page: page)
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
    
    private func validateQuery(query: String) -> Bool {
        if query.isEmpty {
            return false
        } else {
            return true
        }
    }
    
}

public enum TabButtonType {
    case api
    case favorite
}

public enum UserListCellData {
    case user(user: UserListItem, isFavorite: Bool)
    case header(String)
}
