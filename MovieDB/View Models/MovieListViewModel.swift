//
//  MovieListViewModel.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 13/12/20.
//

import Foundation

protocol MovieListViewModelDelegate: AnyObject {
    
    /// Called after cell view models is updated with an optional error.
    func didUpdateViewModels(with error: APIError?)
        
    /// Called whenever collectionview needed to be reloaded for showing placeholders.
    func shouldReloadData()
}


final class MovieListViewModel {
    
    weak var delegate: MovieListViewModelDelegate?

    let title = "Kitabisa Movie Database"
    let categoryMenuOptions = MenuOption.allOptions
    var movieViewModels: [MovieViewModel] = []
    var isShowingPlaceholder: Bool = true
    var selectedCategory: Category = .popular {
        didSet {
            isShowingPlaceholder = true
            delegate?.shouldReloadData()
        }
    }
    
    private let movieDBAPI: MovieDBAPI
    
    
    // MARK: - Init
    
    init(movieDBAPI: MovieDBAPI = MovieDBAPI()) {
        self.movieDBAPI = movieDBAPI
    }
    
    
    // MARK: - Public Functions
    
    func fetchMovies(endpoint: MovieDBEndpoint) {
        movieDBAPI.task?.cancel()
        
        movieDBAPI.fetch(with: endpoint) { [weak self] (result: Result<MovieDBResponse, APIError>) in
            DispatchQueue.main.async {
                self?.isShowingPlaceholder = false
                
                switch result {
                case .success(let response):
                    self?.movieViewModels = response.results.map { MovieViewModel(movie: $0) }
                    self?.delegate?.didUpdateViewModels(with: nil)
                case .failure(let error):
                    self?.delegate?.didUpdateViewModels(with: error)
                }
            }
        }
    }
}
