//
//  UserLocation.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import Foundation

struct UserLocation:Codable {
    let street:UserStreet
    let city: String
    let state: String
    let country: String
    //API會回應Int或String 先不處理
    //let postcode: String?
    let coordinates:UserCoordinates
    let timezone:UserTimezone
}

extension UserLocation: Hashable, Equatable {
    static func == (lhs: UserLocation, rhs: UserLocation) -> Bool {
        return lhs.street == rhs.street &&
        lhs.city == rhs.city &&
        lhs.state == rhs.state &&
        lhs.country == rhs.country &&
        lhs.coordinates == rhs.coordinates &&
        lhs.timezone == rhs.timezone
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(street)
        hasher.combine(city)
        hasher.combine(state)
        hasher.combine(country)
        hasher.combine(coordinates)
        hasher.combine(timezone)
    }
}
