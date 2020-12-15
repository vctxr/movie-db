//
//  MovieCellViewModel.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 13/12/20.
//

import Foundation

struct MovieCellViewModel {
    
    let id: Int
    let title: String
    let releaseDate: String
    let overview: String
    let imagePath: String
    
    init(movie: MovieResult) {
        id = movie.id
        title = movie.title
        releaseDate = movie.releaseDate
        overview = movie.overview
        imagePath = movie.posterPath ?? movie.backdropPath
    }
}
