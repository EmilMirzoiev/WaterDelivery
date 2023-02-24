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

class CreateUserProfileViewController: BaseViewController {
    
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
        
        //Check if a user object has been passed to the view controller.
        if user != nil {
        //If so, call a fillUserInfo method to populate the text fields with the user's information.
            fillUserInfo()
        } else {
            //If not, use the FirebaseAuth module to get the current user's UID and use it to load the user's data from Firebase.
            let userManager = UserManager()
            guard let user = Auth.auth().currentUser else { return }
            userManager.loadUserData(by: user.uid) { [weak self] user in
                self?.user = user
                self?.fillUserInfo()
            }
        }
    }
    
    func prepareUI() {
        submitButton.layer.cornerRadius = 8
        userPhoto.layer.masksToBounds = true
        userPhoto.layer.cornerRadius = 24
        userPhoto.layer.borderWidth = 2
        userPhoto.layer.borderColor = UIColor.lightGray.cgColor
        submitButton.layer.cornerRadius = 8
    }
    
    //Implement the fillUserInfo method to set the text fields' text to the user's name, country, city, street, and zip code, and use the Kingfisher library to load the user's photo from a URL.
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
    
    //Add an IBAction for the submit button, and in the method, update the user's name and address properties with the text field's text, and use the UserManager class to save the user's fields to Firebase.
    @IBAction func submitButtonTapped(_ sender: Any) {
        // Check if all required fields are filled.
        guard let fullname = fullnameTextField.text,
              let country = countryTextField.text,
              let city = cityTextField.text,
              let street = streetTextField.text,
              let zip = zipTextField.text,
//              let image = user?.imageURL,
//              !image.isEmpty,
              !fullname.isEmpty,
              !country.isEmpty,
              !city.isEmpty,
              !street.isEmpty,
              !zip.isEmpty else {
            // If not all required fields are filled, show an alert and return early.
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
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    //Add an IBAction for the edit photo button, and in the method, call a presentPhotoActionSheet method to display an action sheet with options to take a photo or choose one from the photo library.
    @IBAction func editPhotoButtonTapped(_ sender: Any) {
        presentPhotoActionSheet()
    }
}

//Implement the UIImagePickerControllerDelegate and UINavigationControllerDelegate protocols, and in the presentCamera and presentPhotoPicker methods, create and present instances of UIImagePickerController to allow the user to take a photo or choose one from the library.
extension CreateUserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    //In the imagePickerController(_:didFinishPickingMediaWithInfo:) method, get the edited image from the info dictionary, set the image view's image to the selected image, and use the UserManager class to upload the image to Firebase Storage and save the image URL to the user's fields in Firebase.
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
