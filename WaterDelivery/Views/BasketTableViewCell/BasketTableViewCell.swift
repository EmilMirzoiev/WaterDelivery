//
//  BasketTableViewCell.swift
//  WaterDelivery
//
//  Created by Emil on 06.01.23.
//

import UIKit
import Kingfisher
import FirebaseStorage

class BasketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productAmount: UILabel!
    @IBOutlet weak var plusProductButton: UIImageView!
    @IBOutlet weak var minusProductButton: UIImageView!
    var increaseCompletion: (() -> Void)?
    var decreaseCompletion: (() -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeImagesClickable()
        selectionStyle = .none
    }
    
    func fill(with model: BasketProduct) {
        productName.text = "\(model.product.name ?? "")"
        productAmount.text = "\(model.count)"

        let storageManager = StorageManager()
        guard let uid = model.product.uid else { return }
        storageManager.fetchProductImageURL(folderName: "products", uid: uid) { imageURL in
            if let imageURL = imageURL {
                // If the image URL is not nil, use Kingfisher to load the image from the URL
                self.productImageView.kf.setImage(with: imageURL)
            }
        }
    }

    func makeImagesClickable() {
        let plusTap = UITapGestureRecognizer(target: self, action: #selector(self.increaseProductAmount))
        plusProductButton.addGestureRecognizer(plusTap)
        plusProductButton.isUserInteractionEnabled = true
        
        let minusTap = UITapGestureRecognizer(target: self, action: #selector(self.decreaseProductAmount))
        minusProductButton.addGestureRecognizer(minusTap)
        minusProductButton.isUserInteractionEnabled = true
    }
    
    @objc func increaseProductAmount(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            increaseCompletion?()
        }
    }
    
    @objc func decreaseProductAmount(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            decreaseCompletion?()
        }
    }
}
