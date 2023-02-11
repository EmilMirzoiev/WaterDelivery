//
//  OrderCustomisationViewController.swift
//  WaterDelivery
//
//  Created by Emil on 09.02.23.
//

import UIKit
import FirebaseAuth

class OrderCustomTableViewController: UIViewController {
    
    enum OrderCell {
        case textField(Any), switcher(Any), paymentMethod(Any), product(BasketProduct), separator(Any)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutButton: UIButton!
    
    var user: User?
    var order: Order?
    var dataSource: [OrderCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTableView()
        prepareDataSource()
        updateButton()
        checkoutButton.layer.cornerRadius = 8
        
        let userManager = UserManager()
        guard let user = Auth.auth().currentUser else { return }
        userManager.loadUserData(by: user.uid) { [weak self] user in
            self?.user = user
//            self?.fillUserInfo()
        }
    }
    
    //Create a function called updateButton() that updates the title of the checkout button based on the total amount in the basket.
    func updateButton() {
        guard let products = order?.products else { return }
        let basketManager = BasketManager(products: products)
        let totalAmount = basketManager.getTotalAmount()
        let buttonTitle = "Checkout for  \(NSString(format:"%.2f", totalAmount)) €"
        checkoutButton.setTitle(buttonTitle, for: .normal)
        if basketManager.getCount() == 0 {
            checkoutButton.isHidden = true
        } else {
            checkoutButton.isHidden = false
            tableView.backgroundView = nil
        }
    }
    
    @IBAction func checkoutButtonTapped(_ sender: Any) {
    }
    
    func prepareDataSource() {
        dataSource.removeAll()
        
        guard let products = order?.products else { return }
        let basketManager = BasketManager(products: products)
        if basketManager.getCount() > 0 {
            for item in basketManager.products {
                dataSource.append(.product(item))
            }
        } else {
            let emptyBasketLabel = UILabel()
            emptyBasketLabel.text = "Basket is empty"
            emptyBasketLabel.textAlignment = .center
            tableView.backgroundView = emptyBasketLabel
            checkoutButton.isHidden = true
            return
        }
                
        let separator = SeparatorTableViewCell()
        dataSource.append(.separator(separator))
        
        let addressCellModel = OrderTextFieldTableViewCell.Model(value: order?.deliveryAddress ?? "", fieldName: "Delivery Address Street") { value in
            self.order?.deliveryAddress = value
            self.prepareDataSource()
        }
    
        let addressBuildingNumberCellModel = OrderTextFieldTableViewCell.Model(value: order?.buildingNumber ?? "", fieldName: "Delivery Address Building Number") { value in
            self.order?.buildingNumber = value
            self.prepareDataSource()
        }
        
        dataSource.append(.textField(addressCellModel))
        dataSource.append(.textField(addressBuildingNumberCellModel))
        dataSource.append(.separator(separator))
        
        let notificationSwitcherViewModel = OrderSwitcherTableViewCell.Model(value: order?.doNotCallMe ?? false, fieldName: "Call me 30 minutes before delivery") { value in
            self.order?.doNotCallMe = value
            self.prepareDataSource()
        }
        
        let deliveryWithoutContact = OrderSwitcherTableViewCell.Model(value: order?.withoutContact ?? false, fieldName: "Contactless delivery") { value in
            self.order?.withoutContact = value
            self.prepareDataSource()
        }
        
        dataSource.append(.switcher(notificationSwitcherViewModel))
        dataSource.append(.switcher(deliveryWithoutContact))
        
        let paymentMethodModel = OrderSegmentedControlTableViewCell.Model(value: order?.payByCreditCard ?? false) { value in
            self.order?.payByCreditCard = value
            self.prepareDataSource()
        }

        dataSource.append(.paymentMethod(paymentMethodModel))
        
        tableView.reloadData()
        
    }
    
    func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: String(describing: OrderTextFieldTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: OrderTextFieldTableViewCell.self))
        tableView.register(.init(nibName: String(describing: OrderSwitcherTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: OrderSwitcherTableViewCell.self))
        tableView.register(.init(nibName: String(describing: BasketTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: BasketTableViewCell.self))
        tableView.register(SeparatorTableViewCell.self, forCellReuseIdentifier: "SeparatorTableViewCell")
        tableView.register(OrderSegmentedControlTableViewCell.self, forCellReuseIdentifier: "OrderSegmentedControlTableViewCell")
    }
}

extension OrderCustomTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch dataSource[indexPath.row] {
        case .product(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BasketTableViewCell.self), for: indexPath) as! BasketTableViewCell
            cell.fill(with: model)
            return cell
        case .separator(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SeparatorTableViewCell.self), for: indexPath) as! SeparatorTableViewCell
            return cell
        case .textField(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OrderTextFieldTableViewCell.self), for: indexPath) as! OrderTextFieldTableViewCell
            cell.fill(with: model)
            return cell
        case .switcher(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OrderSwitcherTableViewCell.self), for: indexPath) as! OrderSwitcherTableViewCell
            cell.fill(with: model)
            return cell
        case .paymentMethod(let model):
               let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSegmentedControlTableViewCell", for: indexPath) as! OrderSegmentedControlTableViewCell
               cell.fill(with: model)
               return cell
        }
    }
}
