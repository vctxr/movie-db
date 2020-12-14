//
//  Shimmerable.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 13/12/20.
//

import UIKit

protocol Shimmerable where Self: UIView {
    var gradientLayer: CAGradientLayer { get }
    func configureShimmerGradient()
    func animateShimmer(_ animate: Bool)
}

extension Shimmerable {
    
    func configureShimmerGradient() {
        gradientLayer.colors = [UIColor.systemFill.cgColor, UIColor.quaternarySystemFill.cgColor, UIColor.systemFill.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.locations = [0, 0.5, 1]
    }
    
    func animateShimmer(_ animate: Bool) {
        if animate {
            layer.addSublayer(gradientLayer)
            let animation = CABasicAnimation(keyPath: "locations")
            animation.duration = 1.5
            animation.fromValue = [-1.5, -1, 0]
            animation.toValue = [1, 1.5, 2]
            animation.repeatCount = .infinity
            gradientLayer.add(animation, forKey: "shimmerAnimation")
        } else {
            gradientLayer.removeAnimation(forKey: "shimmerAnimation")
            gradientLayer.removeFromSuperlayer()
        }
    }
}
