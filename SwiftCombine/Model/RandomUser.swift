//
//  RandomUser.swift
//  SwiftCombine
//
//  Created by Rex Lin on 2021/10/8.
//

import UIKit

struct RandomUser:Codable {
    let gender:String
    let name:Name
    let location:Location
    let email:String
    let login:Login
    let dob:Dob
    let registered:Registered
    let phone:String
    let cell:String
    let id:Id
    let picture:Picture
    let nat:String
}

struct Name:Codable {
    let title:String
    let first:String
    let last:String
}

struct Location:Codable {
    let street:Street
    let city: String
    let state: String
    let country: String
    //API會回應Int或String 先不處理
    //let postcode: String?
    let coordinates:Coordinates
    let timezone:Timezone
}

struct Street:Codable {
    let number:Int
    let name:String
}

struct Coordinates:Codable {
    let latitude:String
    let longitude:String
}

struct Timezone:Codable {
    let offset: String
    let description: String
}

struct Login:Codable {
    let uuid: String
    let username: String
    let password: String
    let salt: String
    let md5: String
    let sha1: String
    let sha256: String
}

struct Dob:Codable {
    let date: String
    let age: Int
}

struct Registered:Codable {
    let date: String
    let age: Int
}

struct Id:Codable {
    let name:String
}

struct Picture:Codable {
    let large: String
    let medium: String
    let thumbnail: String
}

//---------
struct Info:Codable {
    let seed: String
    let results: Int
    let page: Int
    let version: String
}

//---

struct RandmoUserList:Codable {
    let results:[RandomUser]
    let info:Info
}
