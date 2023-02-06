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
    
    // MARK: - Init
    init(_ url: URL, networkClient: NetworkClient) {
        self.url = url
        self.networkClient = networkClient
    }
    
    // MARK: - Methods
    func load() {
        networkClient.request(from: url)
    }
}
