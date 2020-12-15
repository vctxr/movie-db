//
//  ReviewCollectionViewCell.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 14/12/20.
//

import UIKit

class ReviewCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ReviewCollectionViewCell"
    
    private let avatarImageView: AsyncLoadedImageView = {
        let imageView = AsyncLoadedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.size = CGSize(width: 30, height: 30)
        return imageView
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 12
        return stack
    }()
    
    private let innerVStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private let outterVStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 12
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 0).cgPath
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return super.systemLayoutSizeFitting(CGSize(width: UIDevice.current.safeAreaWidth - 12, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    func configure(with viewModel: ReviewViewModel) {
        authorLabel.text = viewModel.authorName
        usernameLabel.text = viewModel.username
        contentLabel.text = viewModel.content
        
        if let imagePath = viewModel.avatarPath {
            avatarImageView.loadImage(endpoint: .image(size: .w200, path: imagePath))
        } else {
            avatarImageView.backgroundColor = .secondarySystemFill
        }
    }
}


// MARK: - Configurations

extension ReviewCollectionViewCell {
    
    private func configureUI() {
        contentView.backgroundColor = .systemBackground
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    private func configureLayout() {
        innerVStack.addArrangedSubview(authorLabel)
        innerVStack.addArrangedSubview(usernameLabel)
        
        hStack.addArrangedSubview(avatarImageView)
        hStack.addArrangedSubview(innerVStack)
        
        outterVStack.addArrangedSubview(hStack)
        outterVStack.addArrangedSubview(contentLabel)
        
        contentView.addSubview(outterVStack)
        
        let avatarWidthConstraint = avatarImageView.widthAnchor.constraint(equalToConstant: 30)
        avatarWidthConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            avatarWidthConstraint,
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            outterVStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            outterVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            outterVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            outterVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
