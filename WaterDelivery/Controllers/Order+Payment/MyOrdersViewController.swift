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
    var emptyOrdersLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(.init(nibName: "MyOrdersTableViewCell", bundle: nil),                                forCellReuseIdentifier: "MyOrdersTableViewCell")
        getData()
    }
    
    func getData() {
        if let userId = Auth.auth().currentUser?.uid {
            orderManager.loadAllData(by: userId) { [weak self] in
                self?.tableView.reloadData()
                self?.updateEmptyOrdersLabel()
            }
        }
    }
    
    func updateEmptyOrdersLabel() {
        if orderManager.orders.isEmpty {
            if emptyOrdersLabel == nil {
                emptyOrdersLabel = createEmptyOrdersListLabel()
            }
            view.addSubview(emptyOrdersLabel!)
            NSLayoutConstraint.activate([
                emptyOrdersLabel!.centerXAnchor.constraint(
                    equalTo: view.centerXAnchor)
            ])
        } else {
            emptyOrdersLabel?.removeFromSuperview()
        }
    }
    
    func createEmptyOrdersListLabel() -> UILabel {
        let label = UILabel()
        label.text = "No orders yet"
        label.textAlignment = .center
        label.font = UIFont(name: "ABeeZee", size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            label.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
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
                UITableView.automaticDimension
//        150
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
