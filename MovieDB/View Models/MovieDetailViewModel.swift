//
//  MovieDetailViewModel.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 14/12/20.
//

import Foundation

protocol MovieDetailViewModelDelegate: AnyObject {
    
    /// Called after cell view models is updated with an optional error.
    func didUpdateCellViewModels(with error: APIError?)
}

final class MovieDetailViewModel {
    
    weak var delegate: MovieDetailViewModelDelegate?
    
    let title: String
    var movieCellViewModel: MovieCellViewModel
    var movieCellDetailViewModel: MovieCellDetailViewModel?
    var reviewCellViewModels: [ReviewCellViewModel] = []
    var isFetchingReviews: Bool = false
    var isFetchingDetails: Bool = false
    
    private let movieDBAPI: MovieDBAPI

    init(movieDBAPI: MovieDBAPI, movieCellViewModel: MovieCellViewModel) {
        self.movieDBAPI = movieDBAPI
        self.movieCellViewModel = movieCellViewModel
        title = movieCellViewModel.title
    }
    
    func fetchReviews() {
        isFetchingReviews = true
        movieDBAPI.fetch(with: .movieReviews(movieID: movieCellViewModel.id)) { [weak self] (result: Result<MovieReviewResponse, APIError>) in
            self?.isFetchingReviews = false
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.reviewCellViewModels = response.results.map { ReviewCellViewModel(reviewResult: $0) }
                    self?.delegate?.didUpdateCellViewModels(with: nil)
                case .failure(let error):
                    self?.delegate?.didUpdateCellViewModels(with: error)
                }
            }
        }
    }
    
    func fetchDetails() {
        isFetchingDetails = true
        movieDBAPI.fetch(with: .movieDetail(movieID: movieCellViewModel.id)) { [weak self] (result: Result<MovieDetailResponse, APIError>) in
            self?.isFetchingDetails = false
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.movieCellDetailViewModel = MovieCellDetailViewModel(movieDetailResponse: response)
                    self?.delegate?.didUpdateCellViewModels(with: nil)
                case .failure(let error):
                    self?.delegate?.didUpdateCellViewModels(with: error)
                }
            }
        }
    }
}
