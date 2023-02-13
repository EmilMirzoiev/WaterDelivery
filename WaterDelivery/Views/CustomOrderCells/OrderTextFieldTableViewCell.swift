//
//  OrderTextFieldTableViewCell.swift
//  WaterDelivery
//
//  Created by Emil on 09.02.23.
//

import UIKit

class OrderTextFieldTableViewCell: UITableViewCell {
    
    struct Model {
        var value: String
        var fieldName: String
        var completion: ((String) -> Void)?
    }

    @IBOutlet weak var textField: UITextField!
    var completion: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        selectionStyle = .none
    }

    func fill(with model: Any, address: String?) {
        guard let model = model as? Model else { return }
        textField.placeholder = model.fieldName
        textField.text = address ?? model.value
        completion = model.completion
    }
}

extension OrderTextFieldTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {return}
        completion?(text)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismisses the keyboard
        return true
    }
}
