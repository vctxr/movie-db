//
//  MovieCellViewModel.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 13/12/20.
//

import Foundation

struct MovieViewModel {
    
    let id: Int
    let title: String
    let releaseDate: String
    let overview: String
    let imagePath: String
    let popularity: Double
    let voteAverage: Double
    var isFavorite: Bool?
    
    init(movie: MovieResult) {
        id = movie.id
        title = movie.title
        releaseDate = movie.releaseDate
        overview = movie.overview
        imagePath = movie.posterPath ?? movie.backdropPath
        popularity = movie.popularity
        voteAverage = movie.voteAverage
    }
    
    init(movie: Movie) {
        id = Int(movie.id)
        title = movie.title ?? ""
        releaseDate = movie.releaseDate ?? ""
        overview = movie.overview ?? ""
        imagePath = movie.imagePath ?? ""
        popularity = movie.popularity
        voteAverage = movie.voteAverage
    }
}
