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
        prepareUI()
    }

    func prepareUI() {
        layer.borderWidth = 1
        layer.borderColor = AppColors.primary.cgColor
        layer.cornerRadius = 24
        contentView.clipsToBounds = true
        contentView.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    func fill(with model: Order) {
        guard let date = model.createdDate,
              let price = model.orderPrice
        else { return }
        
        orderDate.text = dateFormat(from: date)
        orderPrice.text = "€ \(price)"
        
        var productsText = ""
        for (index, product) in model.products.enumerated() {
            if let name = product.product.name,
               let size = product.product.size {
                productsText += "\(name) - (\(size) L) x\(product.count)\n"
                if index == 2 {
                    productsText += "Tap to see more products..."
                    break
                }
            }
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
    }

    func dateFormat(from model: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        let formattedDateInString = formatter.string(from: model)
        return formattedDateInString
    }
}
