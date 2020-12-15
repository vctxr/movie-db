//
//  MovieCollectionViewCell.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 13/12/20.
//

import UIKit

final class MovieListCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MovieListCollectionViewCell"
    
    private let imageView: AsyncLoadedImageView = {
        let imageView = AsyncLoadedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: ShimmerableLabel = {
        let label = ShimmerableLabel()
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: .systemFont(ofSize: 19, weight: .bold))
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 2
        return label
    }()
    
    private let releaseDateLabel: ShimmerableLabel = {
        let label = ShimmerableLabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let overviewLabel: ShimmerableLabel = {
        let label = ShimmerableLabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 0
        return label
    }()
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
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
    
    func configure(with viewModel: MovieViewModel) {
        titleLabel.text = viewModel.title
        releaseDateLabel.text = viewModel.releaseDate
        overviewLabel.text = viewModel.overview
        imageView.loadImage(endpoint: .image(size: .w200, path: viewModel.imagePath))
    }
    
    func animateShimmer(_ animate: Bool) {
        if animate {
            imageView.image = nil
            titleLabel.text = " "
            releaseDateLabel.text = " "
            overviewLabel.text = "\n\n\n\n\n"
        }
        
        UIView.performWithoutAnimation {
            layoutIfNeeded()
        }
        
        imageView.animateShimmer(animate)
        titleLabel.animateShimmer(animate)
        releaseDateLabel.animateShimmer(animate)
        overviewLabel.animateShimmer(animate)
    }
}


// MARK: - Configurations

extension MovieListCollectionViewCell {
    
    private func configureUI() {
        contentView.backgroundColor = .systemBackground
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 0).cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    private func configureLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(vStack)
        
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(releaseDateLabel)
        vStack.addArrangedSubview(overviewLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            
            vStack.topAnchor.constraint(equalTo: imageView.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            vStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
