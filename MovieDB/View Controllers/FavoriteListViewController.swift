//
//  FavoriteListViewController.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 15/12/20.
//

import UIKit

final class FavoriteListViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 6
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: MovieListCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 20, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var messageView: MessageView = {
        let messageView = MessageView()
        messageView.configure(with: "No Favorites Added Yet", subtitle: "Tap the heart icon in movie details to add it to your favorites!")
        return messageView
    }()
    
    private let viewModel = FavoriteListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavoriteMovies()
    }
    
    deinit {
        print("Deinit called - no memory leaks")
    }
}


// MARK: - View Model Delegate

extension FavoriteListViewController: FavoriteListViewModelDelegate {
    
    func didUpdateFavorites(empty: Bool) {
        empty ? messageView.present(in: view) : messageView.removeFromSuperview()
        collectionView.reloadData()
    }
}


// MARK: - Collection View Delegate and Data Source

extension FavoriteListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movieViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as! MovieListCollectionViewCell
        let movieViewModel = viewModel.movieViewModels[indexPath.row]
        cell.configure(with: movieViewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIDevice.current.safeAreaWidth - 12, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovieViewModel = viewModel.movieViewModels[indexPath.row]
        let detailVC = MovieDetailViewController(movieViewModel: selectedMovieViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


// MARK: - Configurations

extension FavoriteListViewController {
    
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
