//
//  ViewController.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 13/12/20.
//

import UIKit

final class MovieListViewController: UIViewController {
        
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 12, height: 250)
        layout.minimumLineSpacing = 6
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: MovieListCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 20, right: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private let categoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Category", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .kitabisaBlue
        button.addTarget(self, action: #selector(didTapCategory), for: .touchUpInside)
        return button
    }()
    
    private let bottomButtonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .kitabisaBlue
        return view
    }()
    
    private let bottomMenu = BottomMenuView()
    
    private let viewModel = MovieListViewModel(movieDBAPI: MovieDBAPI())

    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        viewModel.delegate = self
        viewModel.fetchMovies(endpoint: .popular)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if bottomMenu.isPresented {
            bottomMenu.dismiss()
        }
    }

    
    // MARK: - Handlers
    
    @objc private func didTapFavorite() {
        
    }
    
    @objc private func didTapCategory() {
        bottomMenu.isPresented ? bottomMenu.dismiss() : bottomMenu.present(in: view, above: categoryButton)
    }
}


// MARK: - View Model Delegate

extension MovieListViewController: MovieListViewModelDelegate {
    
    func didUpdateCellViewModels(with error: APIError?) {
        if let error = error {
            print("Error: \(error)")
            // TODO: Handle fetch error
        }
        collectionView.reloadData()
    }
    
    func shouldReloadData() {
        collectionView.reloadData()
    }
}


// MARK: - Collection View Delegate and Data Source

extension MovieListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewModel.isShowingPlaceholder && viewModel.cellViewModels.isEmpty) ? 3 : viewModel.cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as! MovieListCollectionViewCell
        
        if viewModel.isShowingPlaceholder {
            cell.animateShimmer(true)
        } else {
            cell.animateShimmer(false)
            let movieViewModel = viewModel.cellViewModels[indexPath.row]
            cell.configure(with: movieViewModel)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !viewModel.isShowingPlaceholder else { return }
        let selectedMovieViewModel = viewModel.cellViewModels[indexPath.row]
        let detailVC = MovieDetailViewController(movieCellViewModel: selectedMovieViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


// MARK: - Bottom Menu Delegate

extension MovieListViewController: BottomMenuViewDelegate {
    
    func didSelect(menu: MenuOption) {
        guard menu.category != viewModel.selectedCategory else { return }
        
        viewModel.selectedCategory = menu.category
        
        switch menu.category {
        case .popular:
            viewModel.fetchMovies(endpoint: .popular)
        case .upcoming:
            viewModel.fetchMovies(endpoint: .upcoming)
        case .topRated:
            viewModel.fetchMovies(endpoint: .topRated)
        case .nowPlaying:
            viewModel.fetchMovies(endpoint: .nowPlaying)
        }
    }
}


// MARK: - Configurations

extension MovieListViewController {
    
    private func setupNavigationBar() {
        setNavigationBarLeftTitle(title: viewModel.title, barTint: .kitabisaBlue)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(didTapFavorite))
        
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowRadius = 10
        navigationController?.navigationBar.layer.shadowOpacity = 0.5
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        bottomMenu.menuOptions = viewModel.categoryMenuOptions
        bottomMenu.delegate = self
    }
    
    private func configureLayout() {
        view.addSubview(collectionView)
        view.addSubview(bottomButtonContainerView)
        view.addSubview(categoryButton)
        
        bottomMenu.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: categoryButton.topAnchor),
            
            bottomButtonContainerView.topAnchor.constraint(equalTo: categoryButton.topAnchor),
            bottomButtonContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomButtonContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomButtonContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            categoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            categoryButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
