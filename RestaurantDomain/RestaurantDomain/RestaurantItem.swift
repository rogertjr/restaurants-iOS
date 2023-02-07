//
//  RestaurantItem.swift
//  RestaurantDomain
//
//  Created by Rogério Toledo on 06/02/23.
//

import Foundation

public struct RestaurantItems: Decodable {
    let items: [Restaurant]
}

public struct Restaurant: Decodable, Equatable {
    public let id: UUID
    public let name: String
    public let location: String
    public let distance: Float
    public let ratings: Int
    public let parasols: Int
    
    public init(id: UUID, name: String, location: String, distance: Float, ratings: Int, parasols: Int) {
        self.id = id
        self.name = name
        self.location = location
        self.distance = distance
        self.ratings = ratings
        self.parasols = parasols
    }
}
