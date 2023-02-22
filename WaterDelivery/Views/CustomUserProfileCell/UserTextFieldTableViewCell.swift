//
//  UserTextFieldTableViewCell.swift
//  WaterDelivery
//
//  Created by Emil on 19.02.23.
//

import UIKit

class UserTextFieldTableViewCell: UITableViewCell {
    
    struct Model {
        var value: String
        var fieldName: String
        var completion: ((String) -> Void)?
    }
    @IBOutlet weak var fieldName: UILabel!
    @IBOutlet weak var value: UITextField!
    
    var completion: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func fill(with model: Any) {
        guard let model = model as? Model else { return }
        fieldName.text = model.fieldName
        value.text = model.value
        completion = model.completion
    }
}
