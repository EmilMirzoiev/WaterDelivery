//
//  PaymentViewController.swift
//  WaterDelivery
//
//  Created by Emil on 12.01.23.
//

import UIKit
import Cloudipsp
import FirebaseAuth

class PaymentViewController: BaseViewController, PSPayCallbackDelegate, UITextFieldDelegate  {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var cardInputLayout: PSCardInputLayout!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var cardNumberTextField: PSCardNumberTextField!
    @IBOutlet weak var cardMonthTextField: PSExpMonthTextField!
    @IBOutlet weak var cardYearTextField: PSExpYearTextField!
    @IBOutlet weak var cardCodeTextField: PSCVVTextField!
    
    //Create a variable to store a reference to the PSCloudipspWKWebView, which is the web view used by the Cloudipsp API.
    var cloudipspWebView: PSCloudipspWKWebView!
    private var result: String?
    let userOrderManager = OrderManager()
    var order: Order!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getOrderPrice()
        prepareUI()
        
        //Initialize the Cloudipsp web view and add it to the Payment View Controller's view hierarchy.
        cloudipspWebView = PSCloudipspWKWebView(frame: CGRect(x: 0, y: 64, width: self.view.bounds.width, height: self.view.bounds.height))
        self.view.addSubview(cloudipspWebView)
    }
    
    func prepareUI() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.hideKeyboardWhenTappedAround()
        errorLabel.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Add a method to retrieve the order price and display it in the price text field.
    func getOrderPrice() {
        let totalPrice = order.totalAmount
        priceLabel.text = "\(totalPrice)"
    }
    
    //Add a method to clear the information in the text fields.
    func clearFieldsInfo() {
        cardNumberTextField.text = ""
        cardMonthTextField.text = ""
        cardYearTextField.text = ""
    }
    
    //Implement the action method that will be called when the pay button is pressed. In the pay button action method, create an instance of the PSCloudipspApi class and use it to initiate a payment.
    @IBAction func onPayPressed(_ sender: Any) {
        let generatedOrderId = String(format: "Swift_%d", arc4random())
        let cloudipspApi = PSCloudipspApi(merchant: 1397120, andCloudipspView: self.cloudipspWebView)
        let card = self.cardInputLayout.confirm()
        if (card == nil) {
            showErrorMessage(with: "Please provide card number")
            debugPrint("No card")
        } else {
            let amount = Double(priceLabel.text!)
            guard var amount = amount else { return }
            amount = amount * 100
                let order = PSOrder(order: Int(amount), aStringCurrency: currencyLabel.text!, aIdentifier: generatedOrderId, aAbout: generatedOrderId)
                cloudipspApi?.pay(card, with: order, andDelegate: self)
        }
    }
    
    @IBAction func onTestCardPressed(_ sender: Any) {
        self.cardInputLayout.test()
    }
    
    //Implement the onPaidProcess method from the PSPayCallbackDelegate protocol to handle the results of the payment (e.g. to tell the user how went the payment and to add this order to orders list).
    func onPaidProcess(_ receipt: PSReceipt!) {
        debugPrint("onPaidProcess: %@", receipt.status)
        
        if receipt.status.rawValue == 4 {
            print("Success")
            updateOrdersList()
            clearFieldsInfo()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let failureVC = storyboard.instantiateViewController(withIdentifier: "FailureViewController") as! PaymentFailureViewController
                self.navigationController?.pushViewController(failureVC, animated: true)
        }
    }
    
    func showErrorMessage(with string: String) {
        errorLabel.text = string
        errorLabel.isHidden = false
        cardNumberTextField.layer.borderWidth = 1.0
        cardNumberTextField.layer.borderColor = AppColors.error.cgColor
        cardNumberTextField.layer.cornerRadius = 8
    }
    
    func updateOrdersList() {
        userOrderManager.save(order: order) { [weak self] in
            self?.goToHomegape()
        }
    }
    
    func goToHomegape() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let successVC = storyboard.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
            self.navigationController?.pushViewController(successVC, animated: true)
    }

    func onPaidFailure(_ error: Error!) {
        debugPrint("onPaidFailure: %@", error.localizedDescription)
    }
    
    func onWaitConfirm() {
        debugPrint("onWaitConfirm")
    }
}
