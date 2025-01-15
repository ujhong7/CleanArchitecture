//
//  UserListViewModelTests.swift
//  MVVM+CleanArchitectureTests
//
//  Created by yujaehong on 1/15/25.
//

import Foundation
import XCTest
import RxSwift
import RxCocoa
@testable import MVVM_CleanArchitecture


final class UserListViewModelTests: XCTestCase {
    private var viewModel: UserListViewModel!
    private var usecaseMock: MockUserListUsecase!
    private var disposeBag: DisposeBag!
    private var tabButtonRelay: BehaviorRelay<TabButtonType>!
    private var queryRelay: BehaviorRelay<String>!
    private var saveFavoriteRelay: PublishRelay<UserListItem>!
    private var deleteFavoriteRelay: PublishRelay<Int>!
    private var fetchMoreRelay: PublishRelay<Void>!
    
    var input: UserListViewModel.Input!
    
    override func setUp() {
        super.setUp()
        usecaseMock = MockUserListUsecase()
        viewModel = UserListViewModel(usecase: usecaseMock)
        
        disposeBag = DisposeBag()
        
        tabButtonRelay = BehaviorRelay<TabButtonType>(value: .api)
        queryRelay = BehaviorRelay<String>(value: "")
        saveFavoriteRelay = PublishRelay<UserListItem>()
        deleteFavoriteRelay = PublishRelay<Int>()
        fetchMoreRelay = PublishRelay<Void>()
        
        input = UserListViewModel.Input(
            tabButtonType: tabButtonRelay.asObservable(),
            query: queryRelay.asObservable(),
            saveFavorite: saveFavoriteRelay.asObservable(),
            deleteFavorite: deleteFavoriteRelay.asObservable(),
            fetchMore: fetchMoreRelay.asObservable()
        )
    }
    
    override func tearDown() {
        disposeBag = nil
        viewModel = nil
        usecaseMock = nil
        super.tearDown()
    }
    
    // 쿼리결과가 UserListCellData.user 셀로 잘 변환되는지
    func testFetchUserCellData() {
        
        let expectedUsers = [ UserListItem(id: 1, login: "user1", imageURL: ""),
                              UserListItem(id: 2, login: "user2", imageURL: ""),
                              UserListItem(id: 3, login: "user3", imageURL: "")]
    
        usecaseMock.fetchUserResult = .success(UserListResult(totalCount: 3, incompleteResults: false, items: expectedUsers))
        let expectation = XCTestExpectation(description: "fetchUserResult")

        // When
        let output = viewModel.transform(input: input)
        
        queryRelay.accept("user")
        
        var cellDataResult: [UserListCellData] = []
        output.cellData
            .bind { cellData in
                cellDataResult = cellData
                expectation.fulfill()
            }
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 5.0)

        if case .user(let userItem, _) = cellDataResult.first {
            XCTAssertEqual(userItem.login, "user1")
        } else {
            XCTFail("cellDataResult.first is not .user")
        }
        
    }
    
    //탭 선택시 즐겨찾기목록 뜨는지
    func testFavoriteUserCellData() {
        let expectedUsers = [ UserListItem(id: 1, login: "Ash", imageURL: ""),
                              UserListItem(id: 2, login: "Brown", imageURL: ""),
                              UserListItem(id: 3, login: "Brad", imageURL: "")]
        usecaseMock.favoriteUsersResult = .success(expectedUsers)
        let output = viewModel.transform(input: input)
        tabButtonRelay.accept(.favorite)
        let expectation = XCTestExpectation(description: "favoriteUsersResult")

        
        var cellDataResult: [UserListCellData] = []

        output.cellData.bind { cellData in
            cellDataResult = cellData
            expectation.fulfill()
        }.disposed(by: disposeBag)
        wait(for: [expectation], timeout: 5.0)
        
        if case let .header(title) = cellDataResult.first {
            XCTAssertEqual(title, "A")
        } else {
            XCTFail("First item is not a header")
        }
        
        if case .user(let userItem, let isFavorite) = cellDataResult[1] {
            XCTAssertEqual(userItem.login, "Ash")
            XCTAssertTrue(isFavorite)
        } else {
            XCTFail("cellDataResult[1] is not .user")
        }
        
    }
    
    
}
