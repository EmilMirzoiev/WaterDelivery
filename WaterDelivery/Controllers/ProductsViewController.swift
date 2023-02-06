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
    
    //The array of products is used as the data source for the collection view.
    var products = [Product]()
    
    //An instance of "ProductManager"  is used to take the data from the Firebase, parse it and to fill in an array of products
    var productManager = ProductManager()
    
    //* An instance of "BasketManager"  is used to manage the products in a basket. When the "add" button on a product cell is tapped, the corresponding product will be added to the basket using the "add" method on the basket manager.
    var basketManager = BasketManager(products: [])
    
    //When the view controller's "viewDidLoad" method is called, it sets up the collection view by setting the delegate and data source to be the view controller itself, and by registering a custom collection view cell called "ProductCollectionViewCell" to be used for displaying the products.
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        hideBackButton()
        loadProductData()
    }
    
    func prepareCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(.init(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
    }
    
    func hideBackButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    //The "loadProductData" method uses a "ProductManager" object to retrieve a collection of documents from the Firebase database. Each document represents a product, and the method uses a "Product" struct to parse the data in each document into a new "Product" object. These products are then added to an array of products, which is used as the data source for the collection view.
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
    }
    
    @IBAction func accountDetails(_ sender: Any) {
    }
    
    @IBAction func basketButtonTapped(_ sender: Any) {
    }

}

//The view controller conforms to the UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout protocol, and implements methods for handling the collection view layout, number of sections, number of items, and cell for item at indexPath.
extension ProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //In this extension, the numberOfSections method returns 1, indicating that the collection view has only one section.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    //The collectionView(_:numberOfItemsInSection:) method returns the number of items in the collection view by counting the number of products in the products array.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    //The collectionView(_:cellForItemAt:) method is used to configure the cells of the collection view. This method dequeues a reusable cell of the ProductCollectionViewCell class and configures it with the product at the specified index path by calling the fill(with:) method on the cell and passing in the product. It also sets an action for the button inside the cell, which adds the product to the basketManager and shows an alert with a success message.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        cell.fill(with: products[indexPath.row])
        cell.addButtonTapAction = { [weak self] in
            guard let self = self else { return }
            self.basketManager.add(product: self.products[indexPath.row])
            self.showAlertWithTimer(title: "Success", message: "You successfully added a product to cart")
        }
        return cell
    }
    
    //The collectionView(_:layout:sizeForItemAt:) method defines the size of the cells in the collection view.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width / 2 - 36, height: 250)
    }
    
    //The collectionView(_:layout:minimumLineSpacingForSectionAt:) method defines the minimum line spacing between cells in the collection view.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    //The collectionView(_:layout:insetForSectionAt:) method defines the inset or margins of the cells in the collection view.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12)
    }
}

