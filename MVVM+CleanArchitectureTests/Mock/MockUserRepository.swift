//
//  MockUserRepository.swift
//  MVVM+CleanArchitectureTests
//
//  Created by yujaehong on 1/8/25.
//

import Foundation
@testable import MVVM_CleanArchitecture

public struct MockUserRepository: UserRepositoryProtocol {
    
    public func fetchUser(query: String, page: Int) async -> Result<MVVM_CleanArchitecture.UserListResult, MVVM_CleanArchitecture.NetworkError> {
        .failure(.detaNil)
    }
    
    public func getFavoriteUsers() -> Result<[MVVM_CleanArchitecture.UserListItem], MVVM_CleanArchitecture.CoreDataError> {
        .failure(.entityNotFound(""))
    }
    
    public func saveFavoriteUser(user: MVVM_CleanArchitecture.UserListItem) -> Result<Bool, MVVM_CleanArchitecture.CoreDataError> {
        .failure(.entityNotFound(""))
    }
    
    public func deleteFavoriteUser(userID: Int) -> Result<Bool, MVVM_CleanArchitecture.CoreDataError> {
        .failure(.entityNotFound(""))
    }
    
    
}
