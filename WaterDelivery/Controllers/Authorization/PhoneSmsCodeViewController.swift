//
//  PhoneSmsCodeViewController.swift
//  WaterDelivery
//
//  Created by Emil on 01.01.23.
//

import UIKit
import FirebaseAuth

class PhoneSmsCodeViewController: BaseViewController {
    
    @IBOutlet private weak var codeTextField: UITextField?
    @IBOutlet public weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }

    func prepareUI() {
        loginButton.layer.cornerRadius = 8
    }
    
    //Create an action for the login button and call the verifyCode function on the AuthManager singleton, passing in the code from the text field.
    @IBAction public func loginButtonPressed(_ sender: Any) {
        //Handle error that may occur.
        guard let code = codeTextField?.text, code != "" else {
            showAlert(title: "Error", message: "Please provide a verification code") {}
            return
        }
        //In the verifyCode function's completion handler, check if the user exists in the Firebase database and if yes, show the products view controller and if no, show FillUserDataViewController.
        AuthManager.shared.verifyCode(smsCode: code) { [weak self] success in
            if success {
                if let user = Auth.auth().currentUser {
                    let userManager = UserManager()
                    userManager.checkIfUserExist(id: user.uid) { isExist in
                        if isExist {
                            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
                            let navigationController = UINavigationController.init(rootViewController: viewController)
                            UIApplication.shared.windows.first?.rootViewController = navigationController
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                            
                        } else {
                            userManager.saveUserFields(user: .init(uid: user.uid))
                            self?.showNextVC()
                        }
                    }
                }
            } else {
                self?.showAlert(title: "Error", message: "Something went wrong") {}
                return
            }
        }
    }
    
    func showNextVC() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextScreen = storyBoard.instantiateViewController(withIdentifier: "FillUserDataViewController") as! CreateUserProfileViewController
        self.navigationController?.pushViewController(nextScreen, animated: true)
    }
    
    func showProductsVC() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let products = storyBoard.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
        self.navigationController?.pushViewController(products, animated: true)
    }
}
