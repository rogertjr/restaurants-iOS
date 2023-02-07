//
//  RemoteRestaurantLoader.swift
//  RestaurantDomain
//
//  Created by Rogério Toledo on 06/02/23.
//

import Foundation

public final class RemoteRestaurantLoader {
    // MARK: - Properties
    public typealias RemoteRestaurantLoaderResult = Result<[Restaurant], RemoteRestaurantLoader.Error>
    let url: URL
    let networkClient: NetworkClient
    private let okResponse: Int = 200
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    // MARK: - Init
    public init(_ url: URL, networkClient: NetworkClient) {
        self.url = url
        self.networkClient = networkClient
    }
    
    // MARK: - Methods
    private func successfulValaidation(_ data: Data, response: HTTPURLResponse) -> RemoteRestaurantLoaderResult {
        guard let json = try? JSONDecoder().decode(RestaurantItems.self, from: data), response.statusCode == okResponse else {
            return .failure(.invalidData)
        }
        return .success(json.items)
    }
    
    public func load(completion: @escaping (RemoteRestaurantLoader.RemoteRestaurantLoaderResult) -> Void) {
        networkClient.request(from: url) { [weak self] result in
            guard let self else { return }
            switch result  {
            case let .success((data, response)):
                completion(self.successfulValaidation(data, response: response))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
