//
//  OrderSegmentedControlTableViewCell.swift
//  WaterDelivery
//
//  Created by Emil on 11.02.23.
//

import UIKit

class OrderSegmentedControlTableViewCell: UITableViewCell {
    
    struct Model {
        var value: String
        var completion: ((String) -> Void)?
    }
    
    @IBOutlet weak var paymentTypeSegmentedControl: UISegmentedControl!
    var completion: ((String) -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func fill(with model: Any) {
        guard let model = model as? Model else { return }
        completion = model.completion
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            if let tableView = superview as? UITableView,
               let dataSource = tableView.dataSource as? OrderCustomTableViewController {
                dataSource.order?.paymentMethod = "Cash on Delivery"
                print("Cash on Delivery")
            }
        } else if sender.selectedSegmentIndex == 1 {
            if let tableView = superview as? UITableView,
               let dataSource = tableView.dataSource as? OrderCustomTableViewController {
                dataSource.order?.paymentMethod = "Online Payment"
                print("Online Payment")
            }
        }
    }
}
