//
//  ButtonTableViewCell.swift
//  WaterDelivery
//
//  Created by Emil on 07.02.2023.
//

import UIKit

class ButtonViewModel {
    var buttonName: String = ""
    var completion: (() -> ())?
    
    init(buttonName: String, completion: @escaping () -> Void) {
        self.buttonName = buttonName
        self.completion = completion
    }
}

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!
    
    var completion: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func fill(with model: ButtonViewModel) {
        button.setTitle(model.buttonName, for: .normal)
        completion = model.completion
    }
    
    @IBAction func buttonDidTap(_ sender: Any) {
        completion?()
    }
}
