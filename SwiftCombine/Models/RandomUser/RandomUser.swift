//
//  RandomUser.swift
//  SwiftCombine
//
//  Created by Rex Lin on 2021/10/8.
//

import UIKit

// MARK: - RandomUser

struct RandomUser: Codable, Hashable {
    let gender: String?
    let name: UserName?
    let location: UserLocation?
    let email: String?
    let login: UserLoginData?
    let dob: Dob?
    let registered: Registered?
    let phone: String?
    let cell: String?
    let id: UserId?
    let picture: UserPicture?
    let nat: String?
}

//extension RandomUser {
//    enum CodingKeys: String, CodingKey {
//        case gender
//        case name
//        case location
//        case email
//        case login
//        case dob
//        case registered
//        case phone
//        case cell
//        case id
//        case picture
//        case nat
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        gender = try container.decodeIfPresent(String.self, forKey: .gender)
//        name = try container.decodeIfPresent(UserName.self, forKey: .name)
//        location = try container.decodeIfPresent(UserLocation.self, forKey: .location)
//        email = try container.decodeIfPresent(String.self, forKey: .email)
//        login = try container.decodeIfPresent(UserLoginData.self, forKey: .login)
//        dob = try container.decodeIfPresent(Dob.self, forKey: .dob)
//        registered = try container.decodeIfPresent(Registered.self, forKey: .registered)
//        phone = try container.decodeIfPresent(String.self, forKey: .phone)
//        cell = try container.decodeIfPresent(String.self, forKey: .cell)
//        id = try container.decodeIfPresent(UserId.self, forKey: .id)
//        picture = try container.decodeIfPresent(UserPicture.self, forKey: .picture)
//        nat = try container.decodeIfPresent(String.self, forKey: .nat)
//    }
//}

