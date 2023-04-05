//
//  FillUserDataViewController.swift
//  WaterDelivery
//
//  Created by Emil on 11.01.23.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import Kingfisher

class RegistrationViewController: BaseViewController {
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        
        if user != nil {
            fillUserInfo()
        } else {
            let userManager = UserManager()
            guard let user = Auth.auth().currentUser else { return }
            userManager.loadUserData(by: user.uid) { [weak self] user in
                self?.user = user
                self?.fillUserInfo()
            }
        }
    }
    
    func prepareUI() {
        userPhoto.layer.masksToBounds = true
        userPhoto.layer.cornerRadius = 24
        userPhoto.layer.borderWidth = 2
        userPhoto.layer.borderColor = UIColor.lightGray.cgColor
        submitButton.layer.cornerRadius = 30
    }
    
    func fillUserInfo() {
        fullnameTextField.text = user?.name
        countryTextField.text = user?.address?.country
        cityTextField.text = user?.address?.city
        streetTextField.text = user?.address?.street
        zipTextField.text = user?.address?.zipCode
        
        guard let user = user,
              let source = user.imageURL,
              let sourceURL = URL.init(string: source) else { return }
        userPhoto.kf.setImage(with: sourceURL)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let fullname = fullnameTextField.text,
              let country = countryTextField.text,
              let city = cityTextField.text,
              let street = streetTextField.text,
              let zip = zipTextField.text,
              !fullname.isEmpty,
              !country.isEmpty,
              !city.isEmpty,
              !street.isEmpty,
              !zip.isEmpty else {
            let alert = UIAlertController(title: "Missing Information", message: "Please fill out all fields before proceeding.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        user?.name = fullnameTextField.text
        let userAddress = Address.init(country: countryTextField.text, city: cityTextField.text, street: streetTextField.text, zipCode: zipTextField.text)
        user?.address = userAddress
        
        if let user = user {
            let userManager = UserManager()
            userManager.saveUserFields(user: user)
        }
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
        let navigationController = UINavigationController.init(rootViewController: viewController)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
               window.rootViewController = navigationController
               window.makeKeyAndVisible()
        }
    }
    
    @IBAction func editPhotoButtonTapped(_ sender: Any) {
        presentPhotoActionSheet()
    }
}

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        guard let imageData = image.pngData() else {return}
        userPhoto.image = image
        let storageManager = StorageManager()
        guard let user = user else { return }
        storageManager.uploadAvatarData(userUid: user.uid, imageData: imageData) {
            storageManager.getDownloadURL(folder: "avatars", userUid: user.uid) { [weak self] urlString in
                self?.user?.imageURL = urlString
                let userManager = UserManager()
                userManager.saveUserFields(user: user)
            }
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
