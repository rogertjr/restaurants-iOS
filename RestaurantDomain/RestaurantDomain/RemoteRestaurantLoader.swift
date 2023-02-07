//
//  RemoteRestaurantLoader.swift
//  RestaurantDomain
//
//  Created by Rogério Toledo on 06/02/23.
//

import Foundation

final class RemoteRestaurantLoader {
    // MARK: - Properties
    let url: URL
    let networkClient: NetworkClient
    
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
    func load(completion: @escaping (RemoteRestaurantLoader.Error) -> Void) {
        networkClient.request(from: url) { state in
            switch state {
            case .success: completion(.invalidData)
            case .error: completion(.connectivity)
            }
        }
    }
}
