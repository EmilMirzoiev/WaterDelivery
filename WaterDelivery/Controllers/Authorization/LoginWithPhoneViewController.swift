//
//  LoginWithPhoneViewController.swift
//  WaterDelivery
//
//  Created by Emil on 31.12.22.
//

import UIKit
import FirebaseAuth

class LoginWithPhoneViewController: BaseViewController {
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var sendSmsButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    func prepareUI() {
        phoneNumberTextField.text = "+380"
        sendSmsButton.layer.cornerRadius = 8
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    //Create an IBAction function for the sendSmsButton, which gets the text from the phoneNumberTextField and checks if it's not empty.
    @IBAction func sendSmsButtonTapped(_ sender: Any) {
        guard let phoneNumber = phoneNumberTextField.text, phoneNumber != "" else {
            showAlert(title: "Error", message: "Please write down a phone number") {}
            return
        }
        
        //If it's not empty, it calls the startAuth function on the AuthManager singleton, passing in the phone number and a completion block that presents the PhoneSmsCodeViewController if the startAuth function is successful.
        AuthManager.shared.startAuth(phoneNumber: phoneNumber) { [weak self] success in
            if success {
                self?.presentPhoneSmsVC()
            }
        }
    }

    func presentPhoneSmsVC() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let phoneSms = storyBoard.instantiateViewController(withIdentifier: "PhoneSmsCodeViewController") as! PhoneSmsCodeViewController
        self.navigationController?.pushViewController(phoneSms, animated: true)
    }
}




