//
//  CustomPopup.swift
//  WaterDelivery
//
//  Created by Emil on 08.04.23.
//

import UIKit

class CustomPopup: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var cartImageView: UIImageView!
    @IBOutlet weak var itemAddedToCart: UILabel!
    @IBOutlet weak var viewButton: UIButton!
    
    init() {
        super.init(nibName: "CustomPopup", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func configView() {
        self.view.backgroundColor = .clear
        self.backView.backgroundColor = .black.withAlphaComponent(0.2)
        self.backView.alpha = 0
        
        self.contentView.alpha = 0
        self.contentView.layer.cornerRadius = 15
        self.contentView.clipsToBounds = true
        
        viewButton.setTitleColor(AppColors.background, for: .normal)
        viewButton.titleLabel?.font = UIFont(name: "ABeeZee-Regular", size: 16)
        viewButton.titleLabel?.adjustsFontForContentSizeCategory = true
    }
    
    func appear(sender: UIViewController) {
        sender.present(self, animated: false) {
            self.show()
        }
    }
    
    private func show() {
        UIView.animate(withDuration: 1, delay: 0.1) {
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }
    
    func hideWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut) {
                self.backView.alpha = 0
                self.contentView.alpha = 0
            } completion: { _ in
                self.dismiss(animated: false)
                self.removeFromParent()
            }
        }
    }
    
    @IBAction func viewButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let basketVC = storyboard.instantiateViewController(withIdentifier: "BasketViewController") as! BasketViewController
        if let presentingVC = presentingViewController {
            presentingVC.navigationController?.pushViewController(basketVC, animated: true)
        }
    }
}
