//
//  OrderSegmentedControlTableViewCell.swift
//  WaterDelivery
//
//  Created by Emil on 11.02.23.
//

import UIKit

class OrderSegmentedControlTableViewCell: UITableViewCell {
    
    struct Model {
        var value: Bool
        var completion: ((Bool) -> Void)?
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var completion: ((Bool) -> Void)?
    var value: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func fill(with model: Any) {
        guard let model = model as? Model else { return }
        completion = model.completion
    }
    
    @IBAction func choosePaymentMethodsegmentedControlAction(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            value = false
        case 1:
            value = true
        default:
            print("Something wrong")
        }
    }
}
