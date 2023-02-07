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
