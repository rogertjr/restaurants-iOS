//
//  RemoteRestaurantLoader.swift
//  RestaurantDomain
//
//  Created by Rogério Toledo on 06/02/23.
//

import Foundation

final class RemoteRestaurantLoader {
    // MARK: - Properties
    typealias RemoteRestaurantLoaderResult = Result<[Restaurant], RemoteRestaurantLoader.Error>
    let url: URL
    let networkClient: NetworkClient
    private let okResponse: Int = 200
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    // MARK: - Init
    init(_ url: URL, networkClient: NetworkClient) {
        self.url = url
        self.networkClient = networkClient
    }
    
    // MARK: - Methods
    func load(completion: @escaping (RemoteRestaurantLoader.RemoteRestaurantLoaderResult) -> Void) {
        networkClient.request(from: url) { [weak self] result in
            guard let self else { return }
            switch result  {
            case let .success((data, response)):
                guard let json = try? JSONDecoder().decode(RestaurantItems.self, from: data), response.statusCode == self.okResponse else {
                    return completion(.failure(.invalidData))
                }
                
                completion(.success(json.items))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
