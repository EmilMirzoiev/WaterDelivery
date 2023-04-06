//
//  UserImageTableViewCell.swift
//  WaterDelivery
//
//  Created by Emil on 09.02.23.
//

import UIKit
import Kingfisher

struct ImageViewModel {
    var image: UIImage?
    var imageURL: String?
    var completion: (() -> ())?
    
    init(imageURL: String, completion: @escaping () -> Void) {
        self.imageURL = imageURL
        self.completion = completion
    }
    
    init(image: UIImage) {
        self.image = image
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
        if let source = model.imageURL {
            let sourceURL = URL.init(string: source)
            userAccountImage.kf.setImage(with: sourceURL)
        } else if let image = model.image {
            userAccountImage.image = image
        } else {
            userAccountImage.image = UIImage(named: "appPhoto")
        }
    }
    
    func fill(with model: Any) {
        guard let model = model as? ImageViewModel else { return }
        self.completion = model.completion
        if let source = model.imageURL {
            let sourceURL = URL.init(string: source)
            userAccountImage.kf.setImage(with: sourceURL)
        }
    }
    
    @IBAction func editPhotoButton(_ sender: Any) {
        completion?()
        print("edit photo button tapped")
    }
}
