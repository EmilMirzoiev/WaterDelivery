//
//  OrderSegmentedControlTableViewCell.swift
//  WaterDelivery
//
//  Created by Emil on 11.02.23.
//

import UIKit

class OrderSegmentedControlTableViewCell: UITableViewCell {
    
    struct Model {
        var value: PaymentMethod
        var completion: ((PaymentMethod) -> Void)?
    }
    
    @IBOutlet weak var paymentTypeSegmentedControl: UISegmentedControl!
    var completion: ((PaymentMethod) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func fill(with model: Any) {
        guard let model = model as? Model else { return }
        paymentTypeSegmentedControl.selectedSegmentIndex = model.value.rawValue
        completion = model.completion
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        guard let selectedPaymentMethod = PaymentMethod.init(rawValue: paymentTypeSegmentedControl.selectedSegmentIndex) else { return }
        completion?(selectedPaymentMethod)
    }
}
