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
        
        layer.borderWidth = 1
        layer.borderColor = AppColors.primary.cgColor
        layer.cornerRadius = 24
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        contentView.clipsToBounds = true
    }
    
    func fill(with model: Order) {
        orderDate.text = dateFormat(from: model.createdDate ?? Date())
        orderPrice.text = "€ \(String(describing: model.orderPrice ?? 0.0))"
        
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
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSMakeRange(0, attributedString.length))
        productName.attributedText = attributedString
        
        // calculate the required height of the label based on its content
        let size = productName.sizeThatFits(CGSize(width: productName.frame.size.width,
                                                   height: CGFloat.greatestFiniteMagnitude))
        productName.frame.size.height = size.height
    }
    
    //The cell class also has a "dateFormat(from:)" function that takes a Date object as a parameter,
    //formats it using a DateFormatter, and returns a string representation of the formatted date.
    func dateFormat(from model: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        let formattedDateInString = formatter.string(from: model)
        return formattedDateInString
    }
}
