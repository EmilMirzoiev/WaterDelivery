//
//  UserInfoTableViewCell.swift
//  WaterDelivery
//
//  Created by Emil on 07.02.23.
//

import UIKit

class LabelViewModel {
    var titleLabel: String = ""
    var valueLabel: String = ""
    var competion: ((String) -> Void)?
    
    init(titleLabel: String, valueLabel: String, competion: @escaping (String) -> Void) {
        self.titleLabel = titleLabel
        self.valueLabel = valueLabel
        self.competion = competion
    }
}

class TextFieldViewModel {
    var fieldName: String = ""
    var value: String = ""
    
    var competion: ((String) -> Void)?
    
    init(fieldName: String, value: String, competion: @escaping (String) -> Void) {
        self.fieldName = fieldName
        self.value = value
        self.competion = competion
    }
}

class UserInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    var competion: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func fill(with model: LabelViewModel) {
        titleLabel.text = model.titleLabel
        valueLabel.text = model.valueLabel
        competion = model.competion
    }
}
