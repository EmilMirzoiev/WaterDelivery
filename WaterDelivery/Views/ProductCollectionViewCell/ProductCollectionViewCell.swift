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
    
    //Create a fill method, which fills cell's UI elements with data from a Product model.
    func fill(with model: Product) {
        productNameLabel.text = model.name
        guard let price = model.price else { return }
        priceButton.setTitle("Buy for \(price) €", for: .normal)
        
        // Fetch the product image URL from Firebase Storage
        let storageManager = StorageManager()
        guard let uid = model.uid else { return }
        storageManager.fetchProductImageURL(folderName: "products", uid: uid) { imageURL in
            if let imageURL = imageURL {
                // If the image URL is not nil, use Kingfisher to load the image from the URL
                self.productImageView.kf.setImage(with: imageURL)
            }
        }
    }
    
    //Create an IBAction that is called when the buy button is tapped, which triggers the addButtonTapAction closure), which is called in ProductsViewController and its task is to add a product to basket.
    @IBAction func buyAction(_ sender: Any) {
        addButtonTapAction?()
    }
}
