//
//  ShoppingCartViewController.swift
//  WaterDelivery
//
//  Created by Emil on 06.01.23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

//Conform a class to the UITableViewDataSource and UITableViewDelegate protocols.
class BasketViewController: BaseViewController , UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutButton: UIButton!
    
    //Create a variable for the BasketManager class, which will handle the logic for managing the basket.
    var basketManager: BasketManager?
    
    //In the viewDidLoad() function, set the dataSource and delegate of the table view to self, and register the BasketTableViewCell class as the reusable cell for the table view.
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(.init(nibName: "BasketTableViewCell", bundle: nil), forCellReuseIdentifier: "BasketTableViewCell")
        updateButton()
    }
    
    //Create a function called updateButton() that updates the title of the checkout button based on the total amount in the basket.
    func updateButton() {
        let totalAmount = basketManager?.getTotalAmount()
        let buttonTitle = "Checkout for  \(NSString(format:"%.2f", totalAmount ?? 0.0)) €"
        checkoutButton.setTitle(buttonTitle, for: .normal)
        if basketManager?.getCount() == 0 {
            checkoutButton.isHidden = true
            tableView.backgroundView = createEmptyBasketLabel()
        } else {
            checkoutButton.isHidden = false
            tableView.backgroundView = nil
        }
    }
    
    func createEmptyBasketLabel() -> UILabel {
        let label = UILabel()
        label.text = "Basket is empty"
        label.textAlignment = .center
        return label
    }
    
    
    //Implement the UITableViewDataSource and UITableViewDelegate methods such as numberOfRowsInSection, cellForRowAt, commit editingStyle, and canEditRowAt. In these methods, use the basketManager variable to retrieve and display the products in the basket.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketManager?.getCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketTableViewCell", for: indexPath) as! BasketTableViewCell
        if let product = basketManager?.getProduct(by: indexPath.row) {
            cell.fill(with: product)
            
            //Create two closures for the increase and decrease buttons in the BasketTableViewCell, that updates the basket and the table view when called.
            cell.increaseCompletion =  { [weak self] in
                self?.basketManager?.plus(product: product.product)
                tableView.reloadData()
                self?.updateButton()
            }
            cell.decreaseCompletion = { [weak self] in
                self?.basketManager?.minus(product: product.product)
                tableView.reloadData()
                self?.updateButton()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let product = basketManager?.getProduct(by: indexPath.row) else { return }
            tableView.beginUpdates()
            basketManager?.remove(product: product.product)
            updateButton()
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    //Create a prepare for segue function that passes the order data to the PaymentViewController when the checkout button is tapped.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PaymentViewController {
            guard let currentUser = Auth.auth().currentUser,
                  let basketManager = basketManager else { return }
            let order = Order(products: basketManager.getAllProducts(), condition: .processing, orderPrice: basketManager.getTotalAmount(), userId: currentUser.uid, createdDate: Date(), orderId: Int.random(in: 0..<1000000))
            destination.order = order
        }
    }
}
