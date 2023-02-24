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
        //Call the makeImagesClickable() method to make the plus and minus product image buttons clickable.
        makeImagesClickable()
        //Set the selectionStyle property to .none so that cells are not highlighted when tapped.
        selectionStyle = .none
    }
    
//    Create a new function called fill(with model: BasketProduct) to fill the cell's UI elements with data from a BasketProduct model.
    func fill(with model: BasketProduct) {
        productName.text = "\(model.product.name ?? "")"
        productAmount.text = "\(model.count)"

        // Fetch the product image URL from Firebase Storage
        let storageManager = StorageManager()
        guard let uid = model.product.uid else { return }
        storageManager.fetchProductImageURL(folderName: "products", uid: uid) { imageURL in
            if let imageURL = imageURL {
                // If the image URL is not nil, use Kingfisher to load the image from the URL
                self.productImageView.kf.setImage(with: imageURL)
            }
        }
    }
    
    //Create a new function called makeImagesClickable() to add tap gesture recognizers to the plus and minus product buttons and make them clickable.
    func makeImagesClickable() {
        let plusTap = UITapGestureRecognizer(target: self, action: #selector(self.increaseProductAmount))
        plusProductButton.addGestureRecognizer(plusTap)
        plusProductButton.isUserInteractionEnabled = true
        
        let minusTap = UITapGestureRecognizer(target: self, action: #selector(self.decreaseProductAmount))
        minusProductButton.addGestureRecognizer(minusTap)
        minusProductButton.isUserInteractionEnabled = true
    }
    
    //Create two action methods, increaseProductAmount and decreaseProductAmount which will be called when the corresponding button is clicked. In these methods, increaseCompletion and decreaseCompletion closures will be called. In the table view controller, register the BasketTableViewCell class for reuse and dequeue the cells in the tableView(_:cellForRowAt:) data source method. In the table view controller, set the increaseCompletion and decreaseCompletion closures in the cellForRowAtIndexPath method. These closures will be called when the corresponding button is clicked in the cell. In the table view controller, implement the increaseCompletion and decreaseCompletion closures to update the model and refresh the table view when the plus or minus buttons are clicked.
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
