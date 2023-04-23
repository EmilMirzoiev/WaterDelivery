//
//  CustomTabBarController.swift
//  WaterDelivery
//
//  Created by Emil on 21.04.23.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewController1 = ProductsViewController()
        let viewController2 = BasketViewController()
        
        viewController1.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        viewController2.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        
        viewControllers = [viewController1, viewController2]
    }
}
