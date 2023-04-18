//
//  MyOrdersTableViewCell.swift
//  WaterDelivery
//
//  Created by Emil on 18.01.23.
//

import UIKit

class MyOrdersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    //The cell class has a function "fill(with:)" that takes an "Order" object as a parameter. This function updates the text of the two labels with the values from the Order object.
//    func fill(with model: Order) {
//        orderDate.text = dateFormat(from: model.createdDate ?? Date())
//        orderPrice.text = String(model.orderPrice ?? 0.0)
//
//        var productNameText = ""
//        var productSizeText = ""
//        var productAmountText = ""
//
//        for product in model.products {
//            productNameText += "\(product.product.name ?? "")\n"
//            productSizeText += "\(product.product.size ?? 0.0) -\n"
//            productAmountText += "\(product.count) \n"
//        }
//
//        productName.text = productNameText
//        productSize.text = productSizeText
//        productAmount.text = productAmountText
//    }
    
    func fill(with model: Order) {
        orderDate.text = dateFormat(from: model.createdDate ?? Date())
        orderPrice.text = String(model.orderPrice ?? 0.0)
        
        var productsText = ""
        for product in model.products {
            productsText += "\(product.product.name ?? "") - (\(product.product.size ?? 0.0) L) x\(product.count)\n"
        }
        
        productName.text = productsText
        productName.numberOfLines = 0
        productName.lineBreakMode = .byWordWrapping
        
        let attributedString = NSMutableAttributedString(string: productsText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        productName.attributedText = attributedString
    }
    
    //The cell class also has a "dateFormat(from:)" function that takes a Date object as a parameter, formats it using a DateFormatter, and returns a string representation of the formatted date.
    func dateFormat(from model: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        let formattedDateInString = formatter.string(from: model)
        return formattedDateInString
    }
}
