//
//  User.swift
//  WaterDelivery
//
//  Created by Emil on 29.11.22.
//

import Foundation

struct User: Codable {
    
    var uid: String
    var name: String?
    var address: Address?
    var imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case uid
        case name
        case address
        case imageURL
    }
}

