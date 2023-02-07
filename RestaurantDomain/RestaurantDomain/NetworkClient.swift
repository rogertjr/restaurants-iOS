//
//  NetworkClient.swift
//  RestaurantDomain
//
//  Created by Rogério Toledo on 06/02/23.
//

import Foundation

public protocol NetworkClient {
    typealias NetworkResult = Result<(Data, HTTPURLResponse), Error>
    func request(from url: URL, completion: @escaping (NetworkResult) -> Void )
}

final class NetworkService: NetworkClient {
    // MARK: - Properties
    let session: URLSession
    
    // MARK: - Init
    init(_ session: URLSession) {
        self.session = session
    }
    
    // MARK: - Methods
    func request(from url: URL, completion: @escaping (NetworkResult) -> Void ) {
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                let error = NSError(domain: "Unexpected values", code: -1)
                completion(.failure(error))
            }
        }
        .resume()
    }
}
