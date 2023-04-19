//
//  ProductCollectionViewCell.swift
//  WaterDelivery
//
//  Created by Emil on 06.04.23.
//

import UIKit
import Kingfisher
import FirebaseStorage

class ProductViewCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productSizeLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!

    var addButtonTapAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
        
    }

    func prepareUI() {
        addToCartButton.backgroundColor = .none
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.layer.cornerRadius = 8

        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 8
        productImageView.layer.masksToBounds = true

        productNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        productSizeLabel.font = UIFont.systemFont(ofSize: 14)
        productPriceLabel.font = UIFont.systemFont(ofSize: 14)

        layer.borderWidth = 1
        layer.borderColor = AppColors.primary.cgColor
        layer.cornerRadius = 24
    }

    func fill(with model: Product) {
        guard let name = model.name else { return }
        productNameLabel.text = name

        guard let price = model.price else { return }
        productPriceLabel.text = String(price) + " €"

        guard let size = model.size else { return }
        productSizeLabel.text = String(size) + " L"

        let storageManager = StorageManager()
        guard let uid = model.uid else { return }
        storageManager.fetchProductImageURL(folderName: "products", uid: uid) { imageURL in
            if let imageURL = imageURL {
                self.productImageView.kf.setImage(with: imageURL)
            }
        }
    }
        
    @IBAction func buyAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.addButtonTapAction?()
        }
    }
}

