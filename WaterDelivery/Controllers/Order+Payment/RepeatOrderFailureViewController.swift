//
//  RepeatOrderFailureViewController.swift
//  WaterDelivery
//
//  Created by Emil on 19.04.23.
//

import UIKit

class RepeatOrderFailureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
