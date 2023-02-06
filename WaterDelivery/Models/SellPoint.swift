//
//  SellPoints.swift
//  WaterDelivery
//
//  Created by Emil on 16.01.23.
//

import Foundation
import FirebaseFirestore

struct SellPoint: Codable {
    let geopoint: GeoPoint
    let addressName: String
    let imageURL: String
    let uid: String
    
    enum CodingKeys: String, CodingKey {
        case geopoint
        case addressName
        case imageURL
        case uid
    }
}
