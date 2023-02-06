//
//  OrderDetailsViewController.swift
//  WaterDelivery
//
//  Created by Emil on 23.01.23.
//

import UIKit
import FirebaseAuth

class OrderDetailsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateOfOrderLabel: UILabel!
    @IBOutlet weak var dateOfPriceLabel: UILabel!
    @IBOutlet weak var repeatOrderButton: UIButton!
    
    //Create a variable named "order" of type "Order" to store the order data.
    var order: Order?
    
    //Implement the viewDidLoad() method to set the data source and delegate for the tableView, register the table view cell, and reload the data.
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(.init(nibName: "BasketTableViewCell", bundle: nil), forCellReuseIdentifier: "BasketTableViewCell")
        tableView.reloadData()
        updateUI()
    }
    
    //Implement the updateUI() method to update the UI elements with the order data.
    func updateUI() {
        guard let order = order else { return }
        dateLabel.text = dateFormat(from: order.createdDate ?? Date())
        priceLabel.text = "\(order.orderPrice ?? 0.0)"
        repeatOrderButton.layer.cornerRadius = 8
    }
    
    //Implement the dateFormat(from:) method to format the date into a desired format.
    func dateFormat(from model: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        let formattedDateInString = formatter.string(from: model)
        return formattedDateInString
    }
    
    //Implement the required tableView delegate methods such as numberOfRowsInSection and cellForRowAt.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        order?.products.count ?? 0
    }
    
    //In the cellForRowAt method, fill the table view cell with the order data and hide the plus and minus product buttons.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketTableViewCell", for: indexPath) as! BasketTableViewCell
        
        if let order = order {
            cell.fill(with: order.products[indexPath.row])
        }
        cell.plusProductButton.isHidden = true
        cell.minusProductButton.isHidden = true
        return cell
    }
    
    //Implement the prepare(for:sender:) method to pass the basket data to the BasketViewController.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BasketViewController,
           let order = order {
            destination.basketManager = BasketManager.init(products: order.products)
        }
    }
}
