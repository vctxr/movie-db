//
//  UIViewController+Extensions.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 14/12/20.
//

import UIKit

extension UIViewController {
    
    func setNavigationBarLeftTitle(title: String, barTint: UIColor? = nil) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        
        navigationItem.title = ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        
        if let barTint = barTint {
            navigationController?.navigationBar.barTintColor = barTint
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.tintColor = .white
        }
    }
}
