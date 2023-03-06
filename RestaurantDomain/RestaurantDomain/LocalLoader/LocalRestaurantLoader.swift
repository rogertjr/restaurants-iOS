//
//  LocalRestaurantLoader.swift
//  RestaurantDomain
//
//  Created by Rogério Toledo on 08/02/23.
//

import Foundation

final class LocalRestaurantLoader {
    // MARK: - Properties
    let cache: CacheClient
    let currentDate: () -> Date
    // MARK: - Init
    init(_ cache: CacheClient, currentDate: @escaping () -> Date) {
        self.cache = cache
        self.currentDate = currentDate
    }
    
    // MARK: - Methods
    func save(_ items: [Restaurant], timestamp: Date, completion: @escaping (Error?) -> Void) {
        cache.delete { [weak self] error in
            guard let self else { return}
            if error == nil {
                self.cache.save(items, timestamp: self.currentDate(), completion: completion)
            } else {
                completion(error)
            }
        }
    }
}
