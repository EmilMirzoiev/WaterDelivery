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
    
    init(image: UIImage, completion: @escaping () -> Void ) {
        self.image = image
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
        self.completion = model.completion
        if let source = model.imageURL {
            let sourceURL = URL.init(string: source)
            userAccountImage.kf.setImage(with: sourceURL) { [weak self] _ in
                self?.completion?()
            }
        } else if let image = model.image {
            userAccountImage.image = image
            completion?()
        } else {
            userAccountImage.image = UIImage(named: "appPhoto")
            completion?()
        }
    }
    
    func fill(with model: Any) {
        guard let model = model as? ImageViewModel else { return }
        self.completion = model.completion
        if let source = model.imageURL {
            let sourceURL = URL.init(string: source)
            userAccountImage.kf.setImage(with: sourceURL)
        } else if let image = model.image {
            userAccountImage.image = image
        } else {
            userAccountImage.image = UIImage(named: "appPhoto")
        }
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        
        var viewController = self.superview?.next
        while viewController != nil && !(viewController is UIViewController) {
            viewController = viewController?.next
        }
        if let viewController = viewController as? UserProfileTableViewController {
            viewController.performSegue(withIdentifier: "editProfile", sender: nil)
        }
        
        completion?()
    }
}
