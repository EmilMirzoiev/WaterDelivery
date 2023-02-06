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
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var cardInputLayout: PSCardInputLayout!
    
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
        priceTextField.delegate = self
        currencyTextField.delegate = self
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.hideKeyboardWhenTappedAround()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Add a method to retrieve the order price and display it in the price text field.
    func getOrderPrice() {
        let totalPrice = order.totalAmount
        priceTextField.text = "\(totalPrice)"
        priceTextField.isEnabled = false
        currencyTextField.isEnabled = false
    }
    
    //Add a method to clear the information in the text fields.
    func clearFieldsInfo() {
        priceTextField.isEnabled = true
        currencyTextField.isEnabled = true
        priceTextField.text = ""
        currencyTextField.text = ""
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
            debugPrint("No card")
        } else {
            let amount = Double(priceTextField.text!)
            guard var amount = amount else { return }
            amount = amount * 100
                let order = PSOrder(order: Int(amount), aStringCurrency: currencyTextField.text!, aIdentifier: generatedOrderId, aAbout: generatedOrderId)
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
            goToHomegape()
            updateOrdersList()
            clearFieldsInfo()
        } else {
            print("Change card info")
            showAlert(title: "Error", message: "Payment was not successful. Please try again", completion: {})
        }
    }
    
    func updateOrdersList() {
        userOrderManager.save(order: order)
    }
    
    func goToHomegape() {
        showAlert(title: "Success", message: "Payment was successful. Please wait for delivery") {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let goToHomepage = storyBoard.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
            self.navigationController?.pushViewController(goToHomepage, animated: true)
        }
    }

    func onPaidFailure(_ error: Error!) {
        debugPrint("onPaidFailure: %@", error.localizedDescription)
    }
    
    func onWaitConfirm() {
        debugPrint("onWaitConfirm")
    }
    
    private func showMessage(with text: String) {
        let alertController = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
}
