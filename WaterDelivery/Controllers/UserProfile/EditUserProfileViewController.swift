//
//  EditUserProfileViewController.swift
//  WaterDelivery
//
//  Created by Emil on 23.12.22.
//

import UIKit
import FirebaseAuth
import Kingfisher
import FirebaseFirestore
import FirebaseStorage

class EditUserProfileViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityATextField: UITextField!
    @IBOutlet weak var streetAndBuildingNumberTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var user: User?
    
    override func viewDidLoad() {
        prepareUI()
        
        //Check if the user variable is not nil, if it's not, call the "fillUserInfo()" method. If it is nil, use the UserManager class to load the user's information and then call the "fillUserInfo()" method.
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func prepareUI() {
        userPhoto.layer.masksToBounds = true
        userPhoto.layer.cornerRadius = 24
        userPhoto.layer.borderWidth = 2
        userPhoto.layer.borderColor = UIColor.lightGray.cgColor
        saveButton.layer.cornerRadius = 8
        nameTextField.delegate = self
        phoneNumberTextField.delegate = self
        countryTextField.delegate = self
        cityATextField.delegate = self
        streetAndBuildingNumberTextField.delegate = self
        zipCodeTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
        phoneNumberTextField.isUserInteractionEnabled = false
    }
    
    func fillUserInfo() {
        nameTextField.text = user?.name
        phoneNumberTextField.text = Auth.auth().currentUser?.phoneNumber?.description
        countryTextField.text = user?.address?.country
        cityATextField.text = user?.address?.city
        streetAndBuildingNumberTextField.text = user?.address?.street
        zipCodeTextField.text = user?.address?.zipCode

        guard let user = user,
              let source = user.imageURL,
              let sourceURL = URL.init(string: source) else { return }
        userPhoto.kf.setImage(with: sourceURL)
    }
    
    //Create an IBAction for the save button, in it, update the user variable with the information entered in the text fields and use the UserManager class to save the changes to the database.
    @IBAction func saveAction(_ sender: Any) {
        user?.name = nameTextField.text
        let userAddress = Address.init(country: countryTextField.text, city: cityATextField.text, street: streetAndBuildingNumberTextField.text, zipCode: zipCodeTextField.text)
        user?.address = userAddress
        
        if let user = user {
            let userManager = UserManager()
            userManager.saveUserFields(user: user)
            fillUserInfo()
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //Create an IBAction for the edit photo button, in it, call a "presentPhotoActionSheet()" method to allow the user to choose between taking a new photo or selecting one from their library.
    @IBAction func editPhotoButtonTapped(_ sender: Any) {
        presentPhotoActionSheet()
    }
}

//Implement the UIImagePickerControllerDelegate and UINavigationControllerDelegate protocols and in the "presentPhotoActionSheet()" method, create an action sheet that presents the options for taking a photo or choosing one from the library.
extension EditUserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    //Create methods "presentCamera()" and "presentPhotoPicker()" to handle the camera and photo library options respectively. In these methods, create an instance of UIImagePickerController, set its delegate, and present it.
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
    
    //In the "imagePickerController(_:didFinishPickingMediaWithInfo:)" method, handle the selected image, compress it, and upload it to Firebase Storage using the UserManager class. Update the user's imageURL in the database and update the userPhoto UIImageView with the selected image.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        guard let imageData = image.pngData() else {return}
        saveButton.isEnabled = false
        userPhoto.image = image
        let storageManager = StorageManager()
        guard let user = user else {return}
        storageManager.uploadAvatarData(userUid: user.uid, imageData: imageData) {
            storageManager.getDownloadURL(folder: "avatars", userUid: user.uid) { [weak self] urlString in
                self?.user?.imageURL = urlString
                let userManager = UserManager()
                userManager.saveUserFields(user: user)
                self?.saveButton.isEnabled = true
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
