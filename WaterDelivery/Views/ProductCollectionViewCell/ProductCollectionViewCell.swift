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
    
    
    //Create fetchProductsImage method that fetches the product's image from Firebase Storage and sets it on the productImageView.
    func fetchProductsImage(folderName: String, uid: String) {
        let productRef = Storage.storage().reference().child(folderName).child("\(uid).png")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        productRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
              print(error)
          } else {
            // Data for "folderName/uid.jpg" is returned
              let image = UIImage(data: data!)
              self.productImageView.image = image
          }
        }
    }
    
    //Create a fill method, which fills cell's UI elements with data from a Product model.
    func fill(with model: Product) {
        if let uid = model.uid {
            fetchProductsImage(folderName: "products", uid: uid)
        }
        productNameLabel.text = model.name
        guard let price = model.price else { return }
        priceButton.setTitle("Buy for \(price) €", for: .normal)
    }
    
    //Create an IBAction that is called when the buy button is tapped, which triggers the addButtonTapAction closure), which is called in ProductsViewController and its task is to add a product to basket.
    @IBAction func buyAction(_ sender: Any) {
        addButtonTapAction?()
    }
}
