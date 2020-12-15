//
//  MovieDetailViewModel.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 14/12/20.
//

import Foundation

protocol MovieDetailListViewModelDelegate: AnyObject {
    
    /// Called after view models is updated
    func didUpdateViewModels()
    
    func didUpdateFavorites()
}


final class MovieDetailListViewModel {
    
    weak var delegate: MovieDetailListViewModelDelegate?
    
    let title: String
    var movieViewModel: MovieViewModel
    var movieDetailViewModel: MovieDetailViewModel?
    var reviewViewModels: [ReviewViewModel] = []
    var isFetchingReviews: Bool = false
    var isFetchingDetails: Bool = false
    var fetchDetailError: APIError?
    var fetchReviewError: APIError?
    
    private let movieDBAPI: MovieDBAPI
    private let coreDataService: CoreDataService

    
    // MARK: - Init
    
    init(movieDBAPI: MovieDBAPI = MovieDBAPI(),
         coreDataService: CoreDataService = CoreDataService(),
         movieViewModel: MovieViewModel) {
        
        self.movieDBAPI = movieDBAPI
        self.coreDataService = coreDataService
        self.movieViewModel = movieViewModel
        title = movieViewModel.title
    }
    
    
    // MARK: - Public Functions
    
    func fetchReviews(completion: ((APIError?) -> Void)? = nil) {
        isFetchingReviews = true
        movieDBAPI.fetch(with: .movieReviews(movieID: movieViewModel.id)) { [weak self] (result: Result<MovieReviewResponse, APIError>) in
            self?.isFetchingReviews = false
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.reviewViewModels = response.results.map { ReviewViewModel(reviewResult: $0) }
                    self?.fetchReviewError = nil
                    completion?(nil)
                case .failure(let error):
                    self?.fetchReviewError = error
                    completion?(error)
                }
                
                self?.delegate?.didUpdateViewModels()
            }
        }
    }
    
    func fetchDetails(completion: ((APIError?) -> Void)? = nil) {
        isFetchingDetails = true
        movieDBAPI.fetch(with: .movieDetail(movieID: movieViewModel.id)) { [weak self] (result: Result<MovieDetailResponse, APIError>) in
            self?.isFetchingDetails = false
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.movieDetailViewModel = MovieDetailViewModel(movieDetailResponse: response)
                    self?.fetchDetailError = nil
                    completion?(nil)
                case .failure(let error):
                    self?.fetchDetailError = error
                    completion?(error)
                }
                
                self?.delegate?.didUpdateViewModels()
            }
        }
    }
    
    func addToFavorites(viewModel: MovieViewModel) {
        do {
            try coreDataService.saveMovie(viewModel: viewModel)
            movieViewModel.isFavorite = true
            delegate?.didUpdateFavorites()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeFromFavorites(viewModel: MovieViewModel) {
        do {
            try coreDataService.deleteMovie(id: viewModel.id)
            movieViewModel.isFavorite = false
            delegate?.didUpdateFavorites()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func checkFavorites() {
        let favoriteMovies = coreDataService.fetchMovies()
        if favoriteMovies.first(where: { $0.id == movieViewModel.id }) != nil {
            movieViewModel.isFavorite = true
        } else {
            movieViewModel.isFavorite = false
        }
    }
}
