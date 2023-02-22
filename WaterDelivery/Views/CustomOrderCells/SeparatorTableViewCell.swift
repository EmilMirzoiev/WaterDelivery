//
//  SeparatorTableViewCell.swift
//  WaterDelivery
//
//  Created by Emil on 11.02.23.
//

import UIKit

class SeparatorTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let separatorView = UIView()
        separatorView.backgroundColor = .white
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
