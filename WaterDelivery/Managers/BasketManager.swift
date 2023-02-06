//
//  BasketManager.swift
//  WaterDelivery
//
//  Created by Emil on 06.01.23.
//

import Foundation

class BasketManager {
    
    //  Define an array variable products of type BasketProduct.
    var products = [BasketProduct]()

    //  Create an initializer for the class that takes an array of BasketProduct as a parameter and assigns it to the products variable.
    init(products: [BasketProduct]) {
        self.products = products
    }
    
    //  Create a function named add that takes a Product object as a parameter. Inside the function, check if the product already exists in the products array by iterating through it and comparing the uid of each BasketProduct to the uid of the passed Product. If it exists, call a plus function (to be created later) and pass the Product object. If it doesn't exist, create a new BasketProduct object with the passed Product and a count of 1, and append it to the products array.
    func add(product: Product) {
        let isContain = products.contains { basketProduct in
            basketProduct.product.uid == product.uid
        }
        if isContain {
            plus(product: product)
        } else {
            products.append(.init(product: product, count: 1))
        }
    }
    
    func add(basketProducts: [BasketProduct]) {
        products = basketProducts
    }

    //  Create a function named plus that takes a Product object as a parameter. Inside the function, find the index of the BasketProduct object in the products array that has the same uid as the passed Product object. Once you have the index, increment the count of the BasketProduct object at that index by 1.
    func plus(product: Product) {
        let index = products.firstIndex { basketProduct in
            basketProduct.product.uid == product.uid
        }
        guard let index = index else { return }
        products[index].count += 1
    }

    //  Create a function named minus that takes a Product object as a parameter. Inside the function, find the index of the BasketProduct object in the products array that has the same uid as the passed Product object. Once you have the index, decrement the count of the BasketProduct object at that index by 1. If the count reaches 0, call the remove function (to be created later) and pass the Product object.
    func minus(product: Product) {
        let index = products.firstIndex { basketProduct in
            basketProduct.product.uid == product.uid
        }
        guard let index = index else { return }
        if products[index].count <= 1 {
            remove(product: products[index].product)
        } else {
            products[index].count -= 1
        }
    }

    //  Create a function named remove that takes a Product object as a parameter. Inside the function, find the index of the BasketProduct object in the products array that has the same uid as the passed Product object. Once you have the index, remove the BasketProduct object at that index from the products array.
    func remove(product: Product) {
        let index = products.firstIndex { basketProduct in
            basketProduct.product.uid == product.uid
        }
        guard let index = index else { return }
        products.remove(at: index)
    }

    //  Create a function named getCount that returns the number of elements in the products array.
    func getCount() -> Int {
        products.count
    }

    //  Create a function named getProduct that takes an Int as a parameter and returns the BasketProduct object at that index in the products array.
    func getProduct(by index: Int) -> BasketProduct {
        products[index]
    }

    //  Create a function named getAllProducts that returns the entire products array.
    func getAllProducts() -> [BasketProduct] {
        products
    }

    //  Create a function named getTotalAmount that iterates through the products array and calculates the total amount by multiplying the price of each Product by its count, then returns the result as a Double.
    func getTotalAmount() -> Double {
        var result: Double = 0.0
        for product in products {
            let count = product.count
            if let price = product.product.price {
                result += price * Double(count)
            }
        }
        return result.rounded(toPlaces: 2)
    }

    //  Create a function named clearBasket that removes all elements from the products array.
    func clearBasket() {
        products.removeAll()
    }

}
