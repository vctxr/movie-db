//
//  NoReviewFooterView.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 15/12/20.
//

import UIKit

final class MovieDetailFooterView: UICollectionReusableView {
    
    static let identifier = "MovieDetailFooterView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "No Reviews for this movie"
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Be sure to comeback to check other reviews."
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .center
        return label
    }()
    
    private let spinner =  UIActivityIndicatorView(style: .medium)
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateSpinner(animate: Bool) {
        if animate {
            spinner.startAnimating()
            vStack.isHidden = true
        } else {
            spinner.stopAnimating()
            vStack.isHidden = false
        }
    }
}


// MARK: - Configurations

extension MovieDetailFooterView {
    
    private func configureUI() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLayout() {
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(subTitleLabel)
        
        addSubview(vStack)
        addSubview(spinner)
        
        NSLayoutConstraint.activate([
            vStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
