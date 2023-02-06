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
    
    // MARK: - Init
    init(_ url: URL) {
        self.url = url
    }
    
    // MARK: - Methods
    func load() {
        NetworkClient.shared.request(from: url)
    }
}
