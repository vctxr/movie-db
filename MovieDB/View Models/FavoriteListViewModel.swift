//
//  FavoriteListViewModel.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 15/12/20.
//

import Foundation

protocol FavoriteListViewModelDelegate: AnyObject {
    
    func didUpdateFavorites(empty: Bool)
}


final class FavoriteListViewModel {
    
    weak var delegate: FavoriteListViewModelDelegate?
    
    let title = "Favorite Movie"
    var movieViewModels: [MovieViewModel] = []
    
    private let coreDataService: CoreDataService
    
    
    // MARK: - Init
    
    init(coreDataService: CoreDataService = CoreDataService()) {
        self.coreDataService = coreDataService
    }
    
    
    // MARK: - Public Functions

    func fetchFavoriteMovies() {
        let favoriteMovies = coreDataService.fetchMovies()
        movieViewModels = favoriteMovies.map { MovieViewModel(movie: $0) }
        delegate?.didUpdateFavorites(empty: movieViewModels.isEmpty)
    }
}
