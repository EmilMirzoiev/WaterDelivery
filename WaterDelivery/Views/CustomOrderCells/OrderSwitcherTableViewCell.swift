//
//  OrderSwitcherTableViewCell.swift
//  WaterDelivery
//
//  Created by Emil on 09.02.23.
//

import UIKit

class OrderSwitcherTableViewCell: UITableViewCell {

    struct Model {
        var value: Bool
        var fieldName: String
        var completion: ((Bool) -> Void)?
    }
    
    @IBOutlet weak var switcherNameLabel: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    var completion: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func fill(with model: Any) {
        guard let model = model as? Model else { return }
        switcherNameLabel.text = model.fieldName
        switcher.isOn = model.value
        completion = model.completion
    }

    @IBAction func switcherValueChanged(_ sender: Any) {
        completion?(switcher.isOn)
    }
    
    
}
