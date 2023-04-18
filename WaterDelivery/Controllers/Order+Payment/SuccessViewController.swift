//
//  SuccessViewController.swift
//  WaterDelivery
//
//  Created by Emil on 18.04.23.
//

import UIKit

class SuccessViewController: UIViewController {

    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var dateOfDeliveryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    func prepareUI() {
        okButton.layer.cornerRadius = min(okButton.frame.size.width, okButton.frame.size.height) / 2.0
        okButton.layer.masksToBounds = true
    }

    @IBAction func okTapped(_ sender: Any) {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
}
