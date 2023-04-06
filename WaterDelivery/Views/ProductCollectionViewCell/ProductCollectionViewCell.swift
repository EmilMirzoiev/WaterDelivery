//
//  ProductCollectionViewCell.swift
//  WaterDelivery
//
//  Created by Emil on 20.12.22.
//

import UIKit
import Kingfisher
import FirebaseStorage

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    
    var addButtonTapAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
    }
    
    func prepareUI() {
        priceButton.backgroundColor = .blue
        priceButton.setTitleColor(.white, for: .normal)
        priceButton.layer.cornerRadius = 8
    }
    
    func fill(with model: Product) {
        productNameLabel.text = model.name
        guard let price = model.price else { return }
        priceButton.setTitle("Buy for \(price) €", for: .normal)
        
        let storageManager = StorageManager()
        guard let uid = model.uid else { return }
        storageManager.fetchProductImageURL(folderName: "products", uid: uid) { imageURL in
            if let imageURL = imageURL {
                self.productImageView.kf.setImage(with: imageURL)
            }
        }
    }
    
    @IBAction func buyAction(_ sender: Any) {
        addButtonTapAction?()
    }
}
