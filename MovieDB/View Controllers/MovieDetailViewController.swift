//
//  MovieDetailViewController.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 14/12/20.
//

import UIKit

final class NoReviewsFooterView: UICollectionReusableView {
    
    static let identifier = "NoReviewsFooterView"
    
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

extension NoReviewsFooterView {
    
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

final class MovieDetailViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 6
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(MovieDetailCollectionViewCell.self, forCellWithReuseIdentifier: MovieDetailCollectionViewCell.identifier)
        collectionView.register(ReviewCollectionViewCell.self, forCellWithReuseIdentifier: ReviewCollectionViewCell.identifier)
        collectionView.register(NoReviewsFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NoReviewsFooterView.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 20, right: 0)
        collectionView.delaysContentTouches = false
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private let viewModel: MovieDetailViewModel
    
    init(movieCellViewModel: MovieCellViewModel) {
        viewModel = MovieDetailViewModel(movieDBAPI: MovieDBAPI(), movieCellViewModel: movieCellViewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        viewModel.delegate = self
        viewModel.fetchDetails()
        viewModel.fetchReviews()
    }
}


// MARK: - View Model Delegate

extension MovieDetailViewController: MovieDetailViewModelDelegate {
    
    func didUpdateCellViewModels(with error: APIError?) {
        collectionView.reloadData()
    }
}


// MARK: - Cell Delegate

extension MovieDetailViewController: MovieDetailCollectionViewCellDelegate {
    
    func didTapFavorite(favorite: Bool) {
        print(favorite)
    }
}


// MARK: - Collection View Delegate and Data Source

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : viewModel.reviewCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieDetailCollectionViewCell.identifier, for: indexPath) as! MovieDetailCollectionViewCell
            cell.configure(with: viewModel.movieCellViewModel, and: viewModel.movieCellDetailViewModel)
            cell.delegate = self
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewCell.identifier, for: indexPath) as! ReviewCollectionViewCell
            cell.configure(with: viewModel.reviewCellViewModels[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NoReviewsFooterView.identifier, for: indexPath) as! NoReviewsFooterView
        footer.animateSpinner(animate: viewModel.isFetchingReviews)
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 && viewModel.reviewCellViewModels.isEmpty {
            return CGSize(width: 0, height: 80)
        }
        return .zero
    }
}


// MARK: - Configurations

extension MovieDetailViewController {
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.leftItemsSupplementBackButton = true
        setNavigationBarLeftTitle(title: viewModel.title, barTint: .kitabisaBlue)
    }
    
    private func configureLayout() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
