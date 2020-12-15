//
//  MovieCellDetailViewModel.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 14/12/20.
//

import Foundation

struct MovieDetailViewModel {
    
    let budget: Int
    let revenue: Int
    
    init(movieDetailResponse: MovieDetailResponse) {
        budget = movieDetailResponse.budget
        revenue = movieDetailResponse.revenue
    }
}
