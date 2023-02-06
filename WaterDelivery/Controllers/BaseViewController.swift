//
//  BaseViewController.swift
//  WaterDelivery
//
//  Created by Emil on 21.12.22.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func showAlert(title: String, message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "OK", style: .cancel) { _ in
            completion()
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func showError(_ error: String) {
        let alert = UIAlertController.init(title: "Error", message: error, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction.init(title: "OK", style: .cancel)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func showAlertWithTimer(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        self.present(alert, animated: true, completion: nil)

        // change to desired number of seconds (in this case 1 second)
        let when = DispatchTime.now() + 0.75
        DispatchQueue.main.asyncAfter(deadline: when){
          // code with delay
          alert.dismiss(animated: true, completion: nil)
        }
    }
}

extension BaseViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
