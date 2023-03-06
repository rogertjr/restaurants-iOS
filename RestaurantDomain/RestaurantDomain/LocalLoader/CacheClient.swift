//
//  CacheClient.swift
//  RestaurantDomain
//
//  Created by Rogério Toledo on 24/02/23.
//

import Foundation

protocol CacheClient {
    func save(_ items: [Restaurant], timestamp: Date, completion: @escaping (Error?) -> Void)
    func delete(completion: @escaping (Error?) -> Void)
}
