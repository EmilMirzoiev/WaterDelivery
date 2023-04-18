//
//  PaymentFailureViewController.swift
//  WaterDelivery
//
//  Created by Emil on 18.04.23.
//

import UIKit

class PaymentFailureViewController: UIViewController {
    
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    func prepareUI() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        okButton.layer.cornerRadius = min(okButton.frame.size.width, okButton.frame.size.height) / 2.0
        okButton.layer.masksToBounds = true
        
        tryAgainButton.layer.cornerRadius = min(tryAgainButton.frame.size.width, tryAgainButton.frame.size.height) / 2.0
        tryAgainButton.layer.masksToBounds = true
    }
    
    @IBAction func okTapped(_ sender: Any) {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func tryAgainTapped(_ sender: Any) {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
}
