//
//  Address.swift
//  WaterDelivery
//
//  Created by Emil on 29.11.22.
//

import Foundation

struct Address: Codable {
    
    var country: String?
    var city: String?
    var street: String?
    var zipCode: String?
    
    enum CodingKeys: String, CodingKey {
        case country
        case city
        case street
        case zipCode
    }
}

