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
        createOrderNumber()
    }
    
    func prepareUI() {
        okButton.layer.cornerRadius = min(okButton.frame.size.width, okButton.frame.size.height) / 2.0
        okButton.layer.masksToBounds = true
        
        let currentDate = Date()
        let deliveryDate = Calendar.current.date(byAdding: .day, value: 2, to: currentDate)!
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "d MMMM"
        let formattedDeliveryDate = dateFormatter.string(from: deliveryDate)
                
        dateOfDeliveryLabel.text = """
                We’re preparing your order,
                it will be delivered \(formattedDeliveryDate).
                Relax and wait for your order
                to be delivered to your home.
                """
    }
    
    func createOrderNumber() {
        let randomNumber = Int.random(in: 1...999999)
        orderNumber.text = String(format: "%04d", randomNumber)
    }

    @IBAction func okTapped(_ sender: Any) {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
}
