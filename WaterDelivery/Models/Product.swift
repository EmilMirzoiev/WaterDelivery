//
//  Product.swift
//  WaterDelivery
//
//  Created by Emil on 15.12.22.
//

import Foundation
import FirebaseFirestoreSwift

struct Product: Codable {

    var name: String?
    var price: Double?
    var imageURL: String?
    var uid: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case price
        case imageURL
        case uid
    }
}
