//
//  NetworkClient.swift
//  RestaurantDomain
//
//  Created by Rogério Toledo on 06/02/23.
//

import Foundation

protocol NetworkClient {
    func request(from url: URL, completion: @escaping (Error) -> Void)
}
