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
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        hideKeyboardWhenTappedAround()
    }
    
    func prepareUI() {
        errorLabel.isHidden = true
        phoneNumberTextField.text = "+380988897463"
        sendSmsButton.layer.cornerRadius = 8
        navigationItem.setHidesBackButton(true, animated: true)
        checkBoxButton.setImage(UIImage(named: "checkboxNotActive"), for: .normal)
        checkBoxButton.setImage(UIImage(named: "checkboxActive"), for: .selected)
    }
    
    //Create an IBAction function for the sendSmsButton, which gets the text from the phoneNumberTextField and checks if it's not empty.
    @IBAction func sendSmsButtonTapped(_ sender: Any) {
        guard let phoneNumber = phoneNumberTextField.text, phoneNumber != "" else {
            errorLabel.isHidden = false
//            showAlert(title: "Error", message: "Please enter correct number") {}
            return
        }
        
        //If it's not empty, it calls the startAuth function on the AuthManager singleton, passing in the phone number and a completion block that presents the PhoneSmsCodeViewController if the startAuth function is successful.
        AuthManager.shared.startAuth(phoneNumber: phoneNumber) { [weak self] success in
            if success {
                self?.presentPhoneSmsVC()
            }
        }
    }

    @IBAction func checkBoxTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
        }) { (success) in
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
            }, completion: nil)
        }
    }
    
    
    func presentPhoneSmsVC() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let phoneSms = storyBoard.instantiateViewController(withIdentifier: "PhoneSmsCodeViewController") as! PhoneSmsCodeViewController
        self.navigationController?.pushViewController(phoneSms, animated: true)
    }
}




