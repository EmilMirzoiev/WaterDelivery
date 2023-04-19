//
//  OrderDetailsViewController.swift
//  WaterDelivery
//
//  Created by Emil on 23.01.23.
//

import UIKit
import FirebaseAuth

class OrderDetailsViewController: BaseViewController,
                                  UITableViewDelegate,
                                  UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateOfOrderLabel: UILabel!
    @IBOutlet weak var repeatOrderButton: UIButton!
    
    var order: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(.init(nibName: "BasketTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "BasketTableViewCell")
        tableView.reloadData()
        updateUI()
    }
    
    func updateUI() {
        guard let date = order?.createdDate,
              let price = order?.orderPrice else { return }
        
        dateLabel.text = dateFormat(from: date)
        priceLabel.text = "€\(price)"
        
        repeatOrderButton.layer.cornerRadius =
        min(repeatOrderButton.frame.size.width,
            repeatOrderButton.frame.size.height) / 2.0
        repeatOrderButton.layer.masksToBounds = true
    }
    
    func dateFormat(from model: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        let formattedDateInString = formatter.string(from: model)
        return formattedDateInString
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        order?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "BasketTableViewCell", for: indexPath)
        as! BasketTableViewCell
        
        if let order = order {
            cell.fill(with: order.products[indexPath.row])
        }
        cell.plusButton.isHidden = true
        cell.minusButton.isHidden = true
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BasketViewController,
           let order = order {
            destination.basketManager = BasketManager.init(products: order.products)
        }
    }
}
