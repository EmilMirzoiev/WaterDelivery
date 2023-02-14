//
//  OrderDetailsViewController.swift
//  WaterDelivery
//
//  Created by Emil on 09.02.23.
//

import UIKit
import FirebaseAuth

enum ProfileSections {
    case labels([ProfileCells])
    case buttons([ProfileCells])
    case images([ProfileCells])
}

enum ProfileCells {
    case label(LabelViewModel)
    case button(ButtonViewModel)
    case image(ImageViewModel)
    case separator(CGFloat)
}

class UserProfileTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var user: User?
    var dataSource: [ProfileSections] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        prepareUserProfileTableView()
        loadUserData()
    }
    
    func loadUserData() {
        let userManager = UserManager()
        guard let user = Auth.auth().currentUser else { return }
        userManager.loadUserData(by: user.uid) { [weak self] user in
            self?.user = user
            self?.prepareUserProfileDataSource()
        }
    }
    
    func prepareUserProfileDataSource() {
        
        dataSource.removeAll()
        
        
        guard let image = user?.imageURL else { return }
        let imageViewModel = ImageViewModel (imageURL: image) {
            print("imageURL: \(image)")
        }
        
        let userImage = ProfileCells.image(imageViewModel)
        dataSource.append(.images([userImage]))
        
        
        let userNameTextFieldViewModel = LabelViewModel(titleLabel: "Full name", valueLabel: user?.name ?? "") { [weak self] fullName in
            guard let self = self else { return }
            self.user?.name = fullName
            self.prepareUserProfileDataSource()
        }
        
        let countryTextFieldViewModel = LabelViewModel(titleLabel: "Country", valueLabel: user?.address?.country ?? "", competion: { [weak self] country in
            guard let self = self else { return }
            self.user?.address?.country = country
            self.prepareUserProfileDataSource()
        })
        
        let cityTextFieldViewModel = LabelViewModel(titleLabel: "City", valueLabel: user?.address?.city ?? "", competion: { [weak self] city in
            guard let self = self else { return }
            self.user?.address?.city = city
            self.prepareUserProfileDataSource()
        })
        
        let streetTextFieldViewModel = LabelViewModel(titleLabel: "Street", valueLabel: user?.address?.street ?? "", competion: { [weak self] street in
            guard let self = self else { return }
            self.user?.address?.street = street
            self.prepareUserProfileDataSource()
        })
        
        let zipCodeTextFieldViewModel = LabelViewModel(titleLabel: "Zip Code", valueLabel: user?.address?.zipCode ?? "", competion: { [weak self] zipCode in
            guard let self = self else { return }
            self.user?.address?.zipCode = zipCode
            self.prepareUserProfileDataSource()
        })
        
        let userNameCell = ProfileCells.label(userNameTextFieldViewModel)
        let countryCell = ProfileCells.label(countryTextFieldViewModel)
        let cityCell = ProfileCells.label(cityTextFieldViewModel)
        let streetCell = ProfileCells.label(streetTextFieldViewModel)
        let zipCodeCell = ProfileCells.label(zipCodeTextFieldViewModel)
        let separatorCell = ProfileCells.separator(100)
        
        dataSource.append(.labels([separatorCell, userNameCell, countryCell, cityCell, streetCell, zipCodeCell, separatorCell]))
        
        
        let editProfileViewModel = ButtonViewModel(buttonName: "Edit Profile") {
            self.performSegue(withIdentifier: "editProfile", sender: nil)
        }
        
        let logoutButtonViewModel = ButtonViewModel(buttonName: "Logout") {
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
        
        let editProfileCell = ProfileCells.button(editProfileViewModel)
        let logoutCell = ProfileCells.button(logoutButtonViewModel)
        dataSource.append(.buttons([editProfileCell, logoutCell]))
        
        tableView.reloadData()
        
    }
    
    func prepareUserProfileTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(.init(nibName: "UserInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "UserInfoTableViewCell")
        tableView.register(.init(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "ButtonTableViewCell")
        tableView.register(.init(nibName: "UserImageTableViewCell", bundle: nil), forCellReuseIdentifier: "UserImageTableViewCell")
    }
}

extension UserProfileTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch dataSource[section] {
        case .labels(let textFields):
            return textFields.count
        case .buttons(let buttons):
            return buttons.count
        case .images(let images):
            return images.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch dataSource[indexPath.section] {
        case .images(let images):
            let imageCell = images[indexPath.row]
            switch imageCell {
            case .image(let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserImageTableViewCell", for: indexPath) as! UserImageTableViewCell
                cell.fill(with: viewModel)
                return cell
            default: return UITableViewCell()
            }
        case .labels(let textFields):
            let textFieldCell = textFields[indexPath.row]
            switch textFieldCell {
            case .label(let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoTableViewCell", for: indexPath) as! UserInfoTableViewCell
                cell.fill(with: viewModel)
                return cell
            case .separator(let height):
                let separatorCell = UITableViewCell()
                separatorCell.backgroundColor = .clear
                separatorCell.selectionStyle = .none
                separatorCell.contentView.backgroundColor = .white
                separatorCell.contentView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: height)
                return separatorCell
            default: return UITableViewCell()
            }
        case .buttons(let buttons):
            let buttonCell = buttons[indexPath.row]
            switch buttonCell {
            case .button(let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell", for: indexPath) as! ButtonTableViewCell
                cell.fill(with: viewModel)
                return cell
            default: return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
}
