//
//  RandomUser.swift
//  SwiftCombine
//
//  Created by Rex Lin on 2021/10/8.
//

import UIKit

struct RandomUser:Codable {
    let gender:String
    let name:UserName
    let location:UserLocation
    let email:String
    let login:UserLoginData
    let dob:Dob
    let registered:Registered
    let phone:String
    let cell:String
    let id:UserId
    let picture:UserPicture
    let nat:String
}

extension RandomUser:Hashable, Equatable {
    static func == (lhs: RandomUser, rhs: RandomUser) -> Bool {
        return lhs.gender == rhs.gender &&
        lhs.name == rhs.name &&
        lhs.location == rhs.location &&
        lhs.email == rhs.email &&
        lhs.login == rhs.login &&
        lhs.dob == rhs.dob &&
        lhs.registered == rhs.registered &&
        lhs.phone == rhs.phone &&
        lhs.cell == rhs.cell &&
        lhs.id == rhs.id &&
        lhs.picture == rhs.picture &&
        lhs.nat == rhs.nat
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(gender)
        hasher.combine(name)
        hasher.combine(location)
        hasher.combine(email)
        hasher.combine(login)
        hasher.combine(dob)
        hasher.combine(registered)
        hasher.combine(phone)
        hasher.combine(cell)
        hasher.combine(id)
        hasher.combine(picture)
        hasher.combine(nat)
    }
}
