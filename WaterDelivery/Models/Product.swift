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
    var size: Double?
    var price: Double?
    var imageURL: String?
    var uid: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case size
        case price
        case imageURL
        case uid
    }
}
