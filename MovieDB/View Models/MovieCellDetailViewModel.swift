//
//  MovieCellDetailViewModel.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 14/12/20.
//

import Foundation

struct MovieCellDetailViewModel {
    
    let popularity: Double
    let voteAverage: Double
    
    init(movieDetailResponse: MovieDetailResponse) {
        popularity = movieDetailResponse.popularity
        voteAverage = movieDetailResponse.voteAverage
    }
}
