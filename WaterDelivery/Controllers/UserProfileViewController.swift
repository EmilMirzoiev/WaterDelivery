//
//  UserProfileViewController.swift
//  WaterDelivery
//
//  Created by Emil on 29.12.22.
//

import UIKit
import Kingfisher
import FirebaseAuth
import FirebaseStorage

class UserProfileViewController: BaseViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    
    //Create an instance variable for a "User" object, which will store the user's information.
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    //In the viewWillAppear() method, call a "loadUserData()" method which will be used to retrieve the user's information and fill the UI elements with the data.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            loadUserData()
    }
    
    //Create the loadUserData() method, which will use a UserManager object to retrieve the user's information using the FirebaseAuth library.
    func loadUserData() {
        let userManager = UserManager()
        guard let user = Auth.auth().currentUser else { return }
        userManager.loadUserData(by: user.uid) { [weak self] user in
            self?.fillUserInfo(with: user)
        }
    }
    
    func prepareUI() {
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = 24
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func fillUserInfo(with user: User?) {
        nameLabel.text = user?.name
        phoneNumberLabel.text = Auth.auth().currentUser?.phoneNumber?.description
        countryLabel.text = user?.address?.country
        cityLabel.text = user?.address?.city
        streetLabel.text = user?.address?.street
        zipLabel.text = user?.address?.zipCode
     
        guard let user = user,
              let source = user.imageURL,
              let sourceURL = URL.init(string: source) else { return }
        profileImage.kf.setImage(with: sourceURL)
    }

    @IBAction func editProfileButtonTapped(_ sender: Any) {
    }

    @IBAction func signOutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "initialNavigationController") as! UINavigationController
            self.view.window?.rootViewController = viewController
            self.view.window?.makeKeyAndVisible()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}
