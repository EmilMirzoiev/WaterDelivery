//
//  SplashViewController.swift
//  WaterDelivery
//
//  Created by Emil on 13.12.22.
//

import UIKit
import FirebaseAuth

/* This VC is responsible for determining the initial screen that is displayed to the user when the app is launched.
   It does this by checking if the user is currently logged in with FirebaseAuth.
   If the user is logged in, it will perform a segue to the homepage.
   Otherwise, it will perform a segue to the login screen. */

class SplashViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
            let navigationController = UINavigationController.init(rootViewController: viewController)
            UIApplication.shared.windows.first?.rootViewController = navigationController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        } else {
            performSegue(withIdentifier: "goToLogin", sender: nil)
        }
    }
}
