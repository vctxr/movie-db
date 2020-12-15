//
//  MovieDetailViewController.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 14/12/20.
//

import UIKit

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
        collectionView.register(MovieDetailFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MovieDetailFooterView.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 20, right: 0)
        collectionView.delaysContentTouches = false
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private let viewModel: MovieDetailListViewModel
    
    init(movieViewModel: MovieViewModel) {
        viewModel = MovieDetailListViewModel(movieViewModel: movieViewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        configureViewModel()
    }
    
    deinit {
        print("Deinit called - no memory leaks")
    }
}


// MARK: - View Model Delegate

extension MovieDetailViewController: MovieDetailListViewModelDelegate {
    
    func didUpdateViewModels() {
        collectionView.reloadData()
    }
    
    func didUpdateFavorites() {
        let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? MovieDetailCollectionViewCell
        cell?.configure(with: viewModel.movieViewModel, and: viewModel.movieDetailViewModel)
    }
}


// MARK: - Cell Delegate

extension MovieDetailViewController: MovieDetailCollectionViewCellDelegate {
    
    func didTapFavorite(favorite: Bool) {
        if favorite {
            viewModel.addToFavorites(viewModel: viewModel.movieViewModel)
        } else {
            viewModel.removeFromFavorites(viewModel: viewModel.movieViewModel)
        }
    }
}


// MARK: - Collection View Delegate and Data Source

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : viewModel.reviewViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieDetailCollectionViewCell.identifier, for: indexPath) as! MovieDetailCollectionViewCell
            cell.configure(with: viewModel.movieViewModel, and: viewModel.movieDetailViewModel)
            cell.delegate = self
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewCell.identifier, for: indexPath) as! ReviewCollectionViewCell
            cell.configure(with: viewModel.reviewViewModels[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MovieDetailFooterView.identifier, for: indexPath) as! MovieDetailFooterView
        footer.animateSpinner(animate: viewModel.isFetchingReviews)
        footer.configure(with: viewModel.fetchReviewError)
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 && viewModel.reviewViewModels.isEmpty {
            return CGSize(width: 0, height: 80)
        }
        return .zero
    }
}


// MARK: - Configurations

extension MovieDetailViewController {
    
    private func configureViewModel() {
        viewModel.delegate = self
        viewModel.checkFavorites()
        viewModel.fetchDetails()
        viewModel.fetchReviews()
    }
    
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
