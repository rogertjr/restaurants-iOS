//
//  Date+Ext.swift
//  RestaurantDomainTests
//
//  Created by Rogério Toledo on 08/02/23.
//

import XCTest
import RestaurantDomain

extension Date {
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
