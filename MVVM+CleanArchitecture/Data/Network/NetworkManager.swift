//
//  NetworkManager.swift
//  MVVM+CleanArchitecture
//
//  Created by yujaehong on 1/7/25.
//

import Foundation
import Alamofire

// 구현단 NetworkManager(session: UserSession())
// 테스트 NetworkManager(session: MockSession())

protocol NetworkManagerProtocol {
    func fetchData<T: Decodable>(url: String, method: HTTPMethod, parameters: Parameters?) async -> Result<T, NetworkError>
}

public class NetworkManager: NetworkManagerProtocol {
    
    private let session: SessionProtocol
    
    private let tokenHeader: HTTPHeaders = {
        let tokenHeader = HTTPHeader(name: "Authorization", value: "")
        return HTTPHeaders([tokenHeader])
    }()
    
    init(session: SessionProtocol) {
        self.session = session
    }
    
    func fetchData<T: Decodable>(url: String, method: HTTPMethod, parameters: Parameters?) async -> Result<T, NetworkError> {
        guard let url = URL(string: url) else {
            return .failure(.urlError)
        }
        let result = await session.request(url, method: method, parameters: parameters, headers: tokenHeader).serializingData().response
        if let error = result.error { return .failure(.requestFailed(error.localizedDescription))}
        guard let data = result.data else { return .failure(.detaNil) }
        guard let response = result.response else { return .failure(.invalidResponse) }
        if 200..<400 ~= response.statusCode {
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return .success(decodedData)
            } catch {
                return .failure(.failToDecode(error.localizedDescription))
            }
        } else {
            return .failure(.serverError(response.statusCode))
        }
    }
    
}
