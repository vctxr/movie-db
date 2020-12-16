//
//  ShimmerableLabel.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 14/12/20.
//

import UIKit

final class ShimmerableLabel: UILabel, Shimmerable {
    
    let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureShimmerGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Remove default implicit CALayer animation of 0.25s from frame change
        CATransaction.begin()
        CATransaction.setAnimationDuration(0)
        gradientLayer.frame = bounds
        CATransaction.commit()
    }
}
