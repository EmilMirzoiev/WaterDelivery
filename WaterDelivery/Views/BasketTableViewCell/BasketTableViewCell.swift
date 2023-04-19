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
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productSize: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    
    var increaseCompletion: (() -> Void)?
    var decreaseCompletion: (() -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        prepareUI()
    }
    
    func prepareUI() {
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = AppColors.primary.cgColor
    }
    
    func fill(with model: BasketProduct) {
        guard let name = model.product.name,
              let size = model.product.size,
              let price = model.product.price else { return }
        
        productName.text = "\(name)"
        productAmount.text = "\(model.count)"
        productSize.text = "\(size)"
        productPrice.text = "€\(price)"
        
        let storageManager = StorageManager()
        guard let uid = model.product.uid else { return }
        storageManager.fetchProductImageURL(folderName: "products", uid: uid) { imageURL in
            if let imageURL = imageURL {
                self.productImageView.kf.setImage(with: imageURL)
            }
        }
    }
    
    @IBAction func minusProductButton(_ sender: Any) {
        decreaseCompletion?()

    }
    
    @IBAction func plusProductButton(_ sender: Any) {
        increaseCompletion?()
    }
}
