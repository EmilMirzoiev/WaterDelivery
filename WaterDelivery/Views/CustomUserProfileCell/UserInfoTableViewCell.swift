//
//  UserInfoTableViewCell.swift
//  WaterDelivery
//
//  Created by Emil on 07.02.23.
//

import UIKit

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
