//
//  MovieDBEndpoint.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 13/12/20.
//

import Foundation

enum MovieDBEndpoint: Endpoint {
    case popular
    case upcoming
    case topRated
    case nowPlaying
    case movieDetail(movieID: Int)
    case movieReviews(movieID: Int)
}

extension MovieDBEndpoint {
    
    var baseUrl: String {
        "https://api.themoviedb.org"
    }
    
    var path: String {
        switch self {
        case .popular:
            return "/3/movie/popular"
        case .upcoming:
            return "/3/movie/upcoming"
        case .topRated:
            return "/3/movie/top_rated"
        case .nowPlaying:
            return "/3/movie/now_playing"
        case .movieDetail(movieID: let movieID):
            return "/3/movie/\(movieID)"
        case .movieReviews(movieID: let movieID):
            return "/3/movie/\(movieID)/reviews"
        }
    }
    
    var urlParameters: [URLQueryItem]? {
        [URLQueryItem(name: "api_key", value: "d4d1b5d9aef784eab0d2112a9ffb3ca6")]
    }
}
