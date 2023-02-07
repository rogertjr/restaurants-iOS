//
//  NetworkClient.swift
//  RestaurantDomain
//
//  Created by Rogério Toledo on 06/02/23.
//

import Foundation

enum NetworkState {
    case success
    case error(Error)
}

protocol NetworkClient {
    func request(from url: URL, completion: @escaping (NetworkState) -> Void)
}
