//
//  MyOrdersViewController.swift
//  WaterDelivery
//
//  Created by Emil on 17.01.23.
//

import UIKit
import FirebaseAuth
import Kingfisher

class MyOrdersViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    //In the class body, create an @IBOutlet property named “tableView”. This will be a reference to the UITableView in your storyboard.
    @IBOutlet weak var tableView: UITableView!
    
    //Create a property named "orderManager" of type OrderManager. This will be used to manage the orders that are displayed in the table view.
    let orderManager = OrderManager()
    
    //In the viewDidLoad method, set the table view's dataSource and delegate properties to self, register a custom table view cell class named "MyOrdersTableViewCell", and call the getData method
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(.init(nibName: "MyOrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "MyOrdersTableViewCell")
        getData()
    }
    
    //In the getData method, retrieve the current user's ID from FirebaseAuth and use it to load all orders associated with that user using the orderManager's loadAllData method. Call the table view's reloadData method in the completion handler to refresh the table view's contents.
    func getData() {
        if let userId = Auth.auth().currentUser?.uid {
            orderManager.loadAllData(by: userId) { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    //Implement the tableView(_:numberOfRowsInSection:) method to return the number of orders stored in the orderManager.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderManager.orders.count
    }
    
    //Implement the tableView(_:cellForRowAt:) method to dequeue a reusable table view cell with the identifier "MyOrdersTableViewCell" and fill it with data from the order at the specified index.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrdersTableViewCell", for: indexPath) as! MyOrdersTableViewCell
        cell.fill(with: orderManager.orders[indexPath.row])
        return cell
    }
    
    //Implement the tableView(_:heightForRowAt:) method to return the automatic dimension, which allows the table view cells to dynamically adjust their height based on their contents.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    //Implement the tableView(_:didSelectRowAt:) method to perform a segue with the identifier "goToOrderDetails" and pass the selected order's index as the sender.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToOrderDetails", sender: indexPath.row)
    }

    //In the prepare(for:sender:) method, check if the sender is an Int, and if so, retrieve the corresponding order from the orderManager and pass it to the destination view controller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let index = sender as? Int,
           let destination = segue.destination as? OrderDetailsViewController {
            destination.order = orderManager.orders[index]
        }
    }
}
