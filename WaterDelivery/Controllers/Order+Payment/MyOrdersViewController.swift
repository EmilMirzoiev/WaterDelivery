//
//  MyOrdersViewController.swift
//  WaterDelivery
//
//  Created by Emil on 17.01.23.
//

import UIKit
import FirebaseAuth
import Kingfisher

class MyOrdersViewController: BaseViewController,
                              UITableViewDelegate,
                              UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let orderManager = OrderManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(.init(nibName: "MyOrdersTableViewCell", bundle: nil),                                forCellReuseIdentifier: "MyOrdersTableViewCell")
        getData()
        prepareUI()
    }

    func getData() {
        if let userId = Auth.auth().currentUser?.uid {
            orderManager.loadAllData(by: userId) { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    func prepareUI() {
        if orderManager.orders.isEmpty {
            tableView.backgroundView = nil
        } else {
            tableView.backgroundView = createEmptyOrdersListLabel()
        }
    }
    
    func createEmptyOrdersListLabel() -> UILabel {
        let label = UILabel()
        label.text = "You did not order anyting for now"
        label.textAlignment = .center
        return label
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        orderManager.orders.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MyOrdersTableViewCell",
            for: indexPath) as! MyOrdersTableViewCell
        cell.fill(with: orderManager.orders[indexPath.row])
        return cell
    }
    

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
//        UITableView.automaticDimension
        150
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToOrderDetails",
                     sender: indexPath.row)
    }

    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        if let index = sender as? Int,
           let destination = segue.destination
            as? OrderDetailsViewController {
            destination.order = orderManager.orders[index]
        }
    }
}
