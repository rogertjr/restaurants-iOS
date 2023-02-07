//
//  RestaurantItem.swift
//  RestaurantDomain
//
//  Created by Rogério Toledo on 06/02/23.
//

import Foundation

struct RestaurantItems: Decodable {
    let items: [Restaurant]
}

struct Restaurant: Decodable, Equatable {
    let id: UUID
    let name: String
    let location: String
    let distance: Float
    let ratings: Int
    let parasols: Int
}
