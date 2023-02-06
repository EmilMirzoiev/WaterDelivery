//
//  MyOrdersTableViewCell.swift
//  WaterDelivery
//
//  Created by Emil on 18.01.23.
//

import UIKit

class MyOrdersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var productAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //The cell class has a function "fill(with:)" that takes an "Order" object as a parameter. This function updates the text of the two labels with the values from the Order object.
    func fill(with model: Order) {
        orderDate.text = dateFormat(from: model.createdDate ?? Date())
        productAmountLabel.text = String(model.orderPrice ?? 0.0)
    }
    
    //The cell class also has a "dateFormat(from:)" function that takes a Date object as a parameter, formats it using a DateFormatter, and returns a string representation of the formatted date.
    func dateFormat(from model: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        let formattedDateInString = formatter.string(from: model)
        return formattedDateInString
    }
    
}
