//
//  VerificationViewController.swift
//  WaterDelivery
//
//  Created by Emil on 01.01.23.
//

import UIKit
import FirebaseAuth

class VerificationViewController: BaseViewController {
    
    @IBOutlet private weak var codeTextField: UITextField!
    @IBOutlet public weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var resendCodeButton: UIButton!
    
    var completion: ((Bool) -> Void)?
    private var countdownTimer: Timer?
    private var remainingTime = 0 {
        didSet {
            if remainingTime == 0 {
                resendCodeButton.isEnabled = true
                resendCodeButton.setTitle("Resend Code", for: .normal)
                countdownTimer?.invalidate()
                countdownTimer = nil
            } else {
                resendCodeButton.isEnabled = false
                resendCodeButton.setTitle("Resend Code in \(remainingTime)s", for: .disabled)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    func prepareUI() {
        resendCodeButton.setTitleColor(AppColors.primary, for: .normal)
        resendCodeButton.setTitleColor(AppColors.primary, for: .disabled)
        resendCodeButton.titleLabel?.font = UIFont(name: "ABeeZee-Regular", size: 14)
        resendCodeButton.titleLabel?.adjustsFontForContentSizeCategory = true
        errorLabel.isHidden = true
        loginButton.layer.cornerRadius = min(loginButton.frame.size.width, loginButton.frame.size.height) / 2.0
        loginButton.layer.masksToBounds = true
    }
    
    func showErrorMessage(with string: String) {
        errorLabel.text = string
        errorLabel.isHidden = false
        codeTextField.layer.borderWidth = 1.0
        codeTextField.layer.borderColor = AppColors.error.cgColor
        codeTextField.layer.cornerRadius = 8
    }
    
    private func verifyCode(with code: String) {
        AuthManager.shared.verifyCode(smsCode: code) { [weak self] success in
            if success {
                if let user = Auth.auth().currentUser {
                    let userManager = UserManager()
                    userManager.checkIfUserExist(id: user.uid) { [weak self] isExist in
                        if isExist {
                            let mainStoryboard: UIStoryboard = UIStoryboard(
                                name: "Main", bundle: nil)
                            let viewController = mainStoryboard.instantiateViewController(
                                withIdentifier: "ProductsViewController") as! ProductsViewController
                            let navigationController = UINavigationController.init(
                                rootViewController: viewController)
                            
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let sceneDelegate = windowScene.delegate as? SceneDelegate,
                               let window = sceneDelegate.window {
                                window.rootViewController = navigationController
                                window.makeKeyAndVisible()
                            }
                        } else {
                            userManager.saveUserFields(user: .init(uid: user.uid))
                            self?.showNextVC()
                        }
                    }
                }
            } else {
                self?.showErrorMessage(with: "Please provide correct verification code")
                return
            }
        }
    }
    
    @IBAction public func loginButtonPressed(_ sender: Any) {
        guard let code = codeTextField?.text, code != "" else {
            showErrorMessage(with: "Please enter correct code")
            return
        }
        
        verifyCode(with: code)
    }
    
    @IBAction func resendCodeButtonTapped(_ sender: Any) {
        remainingTime = 59
        countdownTimer = Timer.scheduledTimer(
            withTimeInterval: 1, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                self.remainingTime -= 1
            }
        
        guard let code = codeTextField?.text, code != "" else {
            errorLabel.text = "Please enter correct code"
            errorLabel.isHidden = false
            return
        }
        
        AuthManager.shared.verifyCode(smsCode: code) {_ in }
        
    }
    
    func captchaCompleted() {
        self.dismiss(animated: true, completion: {
            self.completion?(true)
        })
    }
    
    func showNextVC() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextScreen = storyBoard.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
        self.navigationController?.pushViewController(nextScreen, animated: true)
    }
    
    func showProductsVC() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let products = storyBoard.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
        self.navigationController?.pushViewController(products, animated: true)
    }
    
}
