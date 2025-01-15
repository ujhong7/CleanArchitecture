//
//  MockUserUsercase.swift
//  MVVM+CleanArchitectureTests
//
//  Created by yujaehong on 1/15/25.
//

import Foundation
@testable import MVVM_CleanArchitecture

public class MockUserListUsecase: UserListUsecaseProtocol {
    
    public var fetchUserResult: Result<UserListResult, NetworkError>?
    public var favoriteUsersResult: Result<[UserListItem], CoreDataError>?
    
    public func fetchUser(query: String, page: Int) async -> Result<MVVM_CleanArchitecture.UserListResult, MVVM_CleanArchitecture.NetworkError> {
        fetchUserResult ?? .failure(NetworkError.dataNil)
    }
    
    public func getFavoriteUsers() -> Result<[MVVM_CleanArchitecture.UserListItem], MVVM_CleanArchitecture.CoreDataError> {
        favoriteUsersResult ?? .failure(.readError(""))
    }
    
    public func saveFavoriteUser(user: MVVM_CleanArchitecture.UserListItem) -> Result<Bool, MVVM_CleanArchitecture.CoreDataError> {
        .success(true)
    }
    
    public func deleteFavoriteUser(userID: Int) -> Result<Bool, MVVM_CleanArchitecture.CoreDataError> {
        .success(true)
    }
    
    // ⭐️
    public func checkFavoriteState(fetchUsers: [UserListItem], favoriteUsers: [UserListItem]) -> [(user: UserListItem, isFavorite: Bool)] {
        let favoriteSet = Set(favoriteUsers)
        return fetchUsers.map { user in
            if favoriteSet.contains(user) {
                return (user: user, isFavorite: true)
            } else {
                return (user: user, isFavorite: false)
            }
        }
    }
    
    // ⭐️
    public func convertListToDictionary(favoriteUsers: [UserListItem]) -> [String : [UserListItem]] {
        return favoriteUsers.reduce(into: [String : [UserListItem]]()) { dict, user in
            if let firstString = user.login.first { // 초성
                let key = String(firstString).uppercased() //대문자
                dict[key, default: []].append(user)
            }
        }
    }
    
}
