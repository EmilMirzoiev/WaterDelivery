//
//  UserImageTableViewCell.swift
//  WaterDelivery
//
//  Created by Emil on 09.02.23.
//

import UIKit
import Kingfisher

class UserImageTableViewCell: UITableViewCell {

    @IBOutlet weak var userAccountImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUserImage()
        selectionStyle = .none
    }
    
    func prepareUserImage() {
        userAccountImage.layer.masksToBounds = true
        userAccountImage.layer.cornerRadius = 24
        userAccountImage.layer.borderWidth = 2
        userAccountImage.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func fill(with model: ImageViewModel) {
        let source = model.imageURL
        guard let sourceURL = URL.init(string: source) else { return }
        userAccountImage.kf.setImage(with: sourceURL)
    }
    
}
