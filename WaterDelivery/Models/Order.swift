//
//  UserOrders.swift
//  WaterDelivery
//
//  Created by Emil on 17.01.23.
//

import Foundation

struct Order: Codable {
    var products: [BasketProduct] = []
    var condition: Condition?
    var orderPrice: Double?
    var userId: String?
    var createdDate: Date?
    var orderId: Int
    var deliveryAddress: String?
    var buildingNumber: String?
    var doNotCallMe: Bool = false
    var withoutContact: Bool = false
    var payByCreditCard: Bool = false // or true for cash
    
    //  Create a computed property totalAmount that calculates the total amount of the order. This is done by iterating over the products in the order and adding up the price of each item. The result is rounded to two decimal places.
    var totalAmount: Double {
        var result: Double = 0.0
        for product in products {
            let count = product.count
            if let price = product.product.price {
                result += price * Double(count)
            }
        }
        return result.rounded(toPlaces: 2)
    }
}

enum Condition: Codable {
    case processing, shipping, completed, cancelled
}
