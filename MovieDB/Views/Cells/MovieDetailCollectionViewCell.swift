//
//  MovieDetailCollectionViewCell.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 14/12/20.
//

import UIKit

protocol MovieDetailCollectionViewCellDelegate: AnyObject {
    func didTapFavorite(favorite: Bool)
}


final class MovieDetailCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MovieDetailCollectionViewCell"
        
    private let imageView: AsyncLoadedImageView = {
        let imageView = AsyncLoadedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .secondarySystemFill
        imageView.size = CGSize(width: 150, height: 225)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: .systemFont(ofSize: 20, weight: .bold))
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemRed
        return button
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let overviewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Overview"
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        return label
    }()
    
    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .top
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 3
        return stack
    }()
    
    private let popularityTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Popularity"
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let popularityLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let voteAverageTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Vote Average"
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let voteAverageLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let detailHStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let leftVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    private let rightVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    weak var delegate: MovieDetailCollectionViewCellDelegate?
    
    private var isFavorite: Bool = false {
        didSet {
            isFavorite ? favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal) : favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            delegate?.didTapFavorite(favorite: isFavorite)
        }
    }
    
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
        super.systemLayoutSizeFitting(CGSize(width: UIScreen.main.bounds.width - 12, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    @objc private func didTapFavorite() {
        isFavorite.toggle()
    }
    
    func configure(with viewModel: MovieCellViewModel, and detailViewModel: MovieCellDetailViewModel?) {
        titleLabel.text = viewModel.title
        releaseDateLabel.text = viewModel.releaseDate
        overviewLabel.text = viewModel.overview
        imageView.loadImage(endpoint: .image(size: .w200, path: viewModel.imagePath))
        
        guard let detailViewModel = detailViewModel else { return }
        popularityLabel.text = "\(detailViewModel.popularity)"
        voteAverageLabel.text = "\(detailViewModel.voteAverage)"
    }
}


// MARK: - Configurations

extension MovieDetailCollectionViewCell {
    
    private func configureUI() {
        contentView.backgroundColor = .systemBackground
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 0, height: 2)
        
        favoriteButton.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
    }
    
    private func configureLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(vStack)
        contentView.addSubview(detailHStack)
        
        hStack.addArrangedSubview(titleLabel)
        hStack.addArrangedSubview(favoriteButton)
        
        vStack.addArrangedSubview(hStack)
        vStack.addArrangedSubview(releaseDateLabel)
        vStack.addArrangedSubview(overviewTitleLabel)
        vStack.addArrangedSubview(overviewLabel)
        
        vStack.setCustomSpacing(10, after: releaseDateLabel)
        
        leftVStack.addArrangedSubview(popularityTitleLabel)
        leftVStack.addArrangedSubview(popularityLabel)
        
        rightVStack.addArrangedSubview(voteAverageTitleLabel)
        rightVStack.addArrangedSubview(voteAverageLabel)
        
        detailHStack.addArrangedSubview(leftVStack)
        detailHStack.addArrangedSubview(rightVStack)
        
        let imageWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: 150)
        imageWidthConstraint.priority = .defaultHigh

        let imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 225)
        imageHeightConstraint.priority = .defaultHigh
        
        let detailBottomConstraint = detailHStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        detailBottomConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: detailHStack.topAnchor, constant: -20),
            imageWidthConstraint,
            imageHeightConstraint,
            
            vStack.topAnchor.constraint(equalTo: imageView.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            vStack.bottomAnchor.constraint(lessThanOrEqualTo: detailHStack.topAnchor, constant: -20),
            
            detailHStack.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            detailHStack.trailingAnchor.constraint(equalTo: vStack.trailingAnchor),
            detailBottomConstraint
        ])
    }
}
