//
//  EditUserProfileTableViewController.swift
//  WaterDelivery
//
//  Created by Emil on 19.02.23.
//

import UIKit
import FirebaseAuth

class EditUserProfileTableViewController: BaseViewController {
    
    enum EditUserProfileCell {
        case textField(Any), image(Any)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    var user: User?
    var dataSource: [EditUserProfileCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        prepareTableView()
        loadUserData()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        if let user = user {
            let userManager = UserManager()
            userManager.saveUserFields(user: user)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func getText(from indexPath: IndexPath) -> String {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserTextFieldTableViewCell else { return "" }
        return cell.value.text ?? ""
    }
    
    func loadUserData() {
        let userManager = UserManager()
        guard let user = Auth.auth().currentUser else { return }
        userManager.loadUserData(by: user.uid) { [weak self] user in
            self?.user = user
            self?.prepareDataSource()
        }
    }
    
    func prepareUI() {
        saveButton.layer.cornerRadius = 8
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
    }
    
    func prepareDataSource() {
        dataSource.removeAll()
        
        if let image = user?.imageURL {
            let imageViewModel = ImageViewModel (imageURL: image) {
                self.presentPhotoActionSheet()
            }
            dataSource.append(.image(imageViewModel))
        } else {
            // If the user's image URL is nil, add a default image view model.
            let defaultImageURL = "https://firebasestorage.googleapis.com/v0/b/waterdelivery-6fadd.appspot.com/o/avatars%2FdefaultAvatar.jpg?alt=media&token=fe29b3a9-4464-4f48-b490-55b3362d98a8"
            let defaultImageViewModel = ImageViewModel(imageURL: defaultImageURL) {
                self.presentPhotoActionSheet()
                print("default user image")
            }
            dataSource.append(.image(defaultImageViewModel))
        }
        
        let usernameCellModel = UserTextFieldTableViewCell.Model(value: user?.name ?? "", fieldName: "Username") { value in
            self.user?.name = value
            self.prepareDataSource()
        }
        
        let userCountryCellModel = UserTextFieldTableViewCell.Model(value: user?.address?.country ?? "", fieldName: "Country") { value in
            self.user?.address?.country = value
            self.prepareDataSource()
        }
        
        let userCityCellModel = UserTextFieldTableViewCell.Model(value: user?.address?.city ?? "", fieldName: "City") { value in
            self.user?.address?.city = value
            self.prepareDataSource()
        }
        
        let userStreetCellModel = UserTextFieldTableViewCell.Model(value: user?.address?.street ?? "", fieldName: "Street and Building") { value in
            self.user?.address?.street = value
            self.prepareDataSource()
        }
        
        let userZipCodeCellModel = UserTextFieldTableViewCell.Model(value: user?.address?.zipCode ?? "", fieldName: "Zip Code") { value in
            self.user?.address?.zipCode = value
            self.prepareDataSource()
        }
        
        dataSource.append(.textField(usernameCellModel))
        dataSource.append(.textField(userCountryCellModel))
        dataSource.append(.textField(userCityCellModel))
        dataSource.append(.textField(userStreetCellModel))
        dataSource.append(.textField(userZipCodeCellModel))
        
        tableView.reloadData()
    }
    
    func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: String(describing: UserTextFieldTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UserTextFieldTableViewCell.self))
        tableView.register(.init(nibName: String(describing: UserImageTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UserImageTableViewCell.self))
    }
    
    @objc func hideKeyboard() {
        tableView.endEditing(true)
    }
}

extension EditUserProfileTableViewController: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch dataSource[indexPath.row] {
        case .image(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserImageTableViewCell", for: indexPath) as! UserImageTableViewCell
            cell.fill(with: model)
            return cell
        case .textField(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserTextFieldTableViewCell.self), for: indexPath) as! UserTextFieldTableViewCell
            cell.fill(with: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


extension EditUserProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
        let storageManager = StorageManager()
        guard let user = user else {return}
        storageManager.uploadAvatarData(userUid: user.uid, imageData: imageData) {
            storageManager.getDownloadURL(folder: "avatars", userUid: user.uid) { [weak self] urlString in
                self?.user?.imageURL = urlString
                let userManager = UserManager()
                userManager.saveUserFields(user: user)
                
                if let cell = self?.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? UserImageTableViewCell {
                    cell.userAccountImage.image = image
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
