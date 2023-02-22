//
//  UserImageTableViewCell.swift
//  WaterDelivery
//
//  Created by Emil on 09.02.23.
//

import UIKit
import Kingfisher

struct ImageViewModel {
    var imageURL: String = ""
    var completion: (() -> ())?
    
    init(imageURL: String, completion: @escaping () -> Void) {
        self.imageURL = imageURL
        self.completion = completion
    }
}

class UserImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var editPhoto: UIButton!
    @IBOutlet weak var userAccountImage: UIImageView!
    var completion: (() -> ())?
    
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
    
    
    func fill(with model: Any) {
        guard let model = model as? ImageViewModel else { return }
        self.completion = model.completion
        let source = model.imageURL
        guard let sourceURL = URL.init(string: source) else { return }
        userAccountImage.kf.setImage(with: sourceURL)
    }
    
    
    @IBAction func editPhotoButton(_ sender: Any) {
        completion?()
        print("edit photo button tapped")
    }
}
