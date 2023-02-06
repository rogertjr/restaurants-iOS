//
//  NetworkClient.swift
//  RestaurantDomain
//
//  Created by Rogério Toledo on 06/02/23.
//

import Foundation

final class NetworkClient {
    // MARK: - Properties
    static let shared: NetworkClient = NetworkClient()
    private (set) var urlRequest: URL?
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Methods
    func request(from url: URL) {
        urlRequest = url
    }
}
