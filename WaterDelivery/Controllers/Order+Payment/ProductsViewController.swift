//
//  ProductsViewController.swift
//  WaterDelivery
//
//  Created by Emil on 20.12.22.
//

import UIKit
import FirebaseAuth

class ProductsViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var products = [Product]()
    var productManager = ProductManager()
    var basketManager = BasketManager(products: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        hideBackButton()
        loadProductData()
    }
    
    func prepareCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(.init(nibName: "ProductViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "ProductViewCell")
        
    }
    
    func hideBackButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func loadProductData() {
        productManager.loadProductData { [weak self] products in
            self?.products = products
            self?.collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BasketViewController {
            destination.basketManager = basketManager
        }
        if let destination = segue.destination as? OrderCustomTableViewController {
            guard let currentUser = Auth.auth().currentUser else { return }
            let order = Order(products: basketManager.getAllProducts(),
                              condition: .processing,
                              orderPrice: basketManager.getTotalAmount(),
                              userId: currentUser.uid, createdDate: Date(),
                              orderId: Int.random(in: 0..<1000000))
            destination.order = order
        }
    }
    
    @IBAction func accountDetails(_ sender: Any) {
    }
    
    @IBAction func basketButtonTapped(_ sender: Any) {
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(
                withIdentifier: "initialNavigationController") as! UINavigationController
            self.view.window?.rootViewController = viewController
            self.view.window?.makeKeyAndVisible()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}

extension ProductsViewController: UICollectionViewDelegate,
                                  UICollectionViewDataSource,
                                  UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ProductViewCell", for: indexPath) as! ProductViewCell
        cell.fill(with: products[indexPath.row])
        cell.addButtonTapAction = { [weak self] in
            guard let self = self else { return }
            self.basketManager.add(product: self.products[indexPath.row])
            let popup = CustomPopup()
            popup.appear(sender: self)
            popup.hideWithDelay()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 160, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12)
    }
}

