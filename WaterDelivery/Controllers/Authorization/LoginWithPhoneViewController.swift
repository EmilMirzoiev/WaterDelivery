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
        sendSmsButton.layer.cornerRadius = min(sendSmsButton.frame.size.width, sendSmsButton.frame.size.height) / 2.0
        sendSmsButton.layer.masksToBounds = true
        navigationItem.setHidesBackButton(true, animated: true)
        checkBoxButton.setImage(UIImage(named: "checkboxNotActive"), for: .normal)
        checkBoxButton.setImage(UIImage(named: "checkboxActive"), for: .selected)
    }
    
    func showErrorMessage(with string: String) {
        errorLabel.text = string
        errorLabel.isHidden = false
        phoneNumberTextField.layer.borderWidth = 1.0
        phoneNumberTextField.layer.borderColor = AppColors.error.cgColor
        phoneNumberTextField.layer.cornerRadius = 8
    }
    
    @IBAction func sendSmsButtonTapped(_ sender: Any) {
        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            showErrorMessage(with: "Please enter a phone number.")
            return
        }
        
        let phoneRegex = "^\\+?[0-9]{7,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        if !phoneTest.evaluate(with: phoneNumber) {
            showErrorMessage(with: "Please enter a valid phone number.")
            return
        }
        
        errorLabel.isHidden = true
        phoneNumberTextField.layer.borderColor = UIColor.clear.cgColor
        
        guard checkBoxButton.isSelected else {
            errorLabel.text = "Please agree to the terms and conditions."
            errorLabel.isHidden = false
            return
        }
        
        sendSmsButton.isEnabled = false
        sendSmsButton.backgroundColor = AppColors.inputs
        
        AuthManager.shared.startAuth(phoneNumber: phoneNumber) { [weak self] success in
            self?.sendSmsButton.isEnabled = true
            self?.sendSmsButton.backgroundColor = AppColors.primary
            
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
        let phoneSms = storyBoard.instantiateViewController(withIdentifier: "VerificationViewController") as! VerificationViewController
        phoneSms.completion = { [weak self] success in
            if success {
                let createUserProfileVC = storyBoard.instantiateViewController(withIdentifier: "RegistrationViewController")
                self?.navigationController?.pushViewController(createUserProfileVC, animated: true)
            }
        }
        self.navigationController?.pushViewController(phoneSms, animated: true)
    }
    
    
}




