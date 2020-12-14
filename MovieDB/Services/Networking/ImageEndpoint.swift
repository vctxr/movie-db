//
//  ImageEndpoint.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 13/12/20.
//

import Foundation

enum ImageSize: String {
    case w200
    case w300
    case w400
    case w500
}

enum ImageEndpoint: Endpoint {
    case image(size: ImageSize, path: String)
}

extension ImageEndpoint {
    var baseUrl: String {
        "https://image.tmdb.org"
    }
    
    var path: String {
        switch self {
        case .image(size: let imageSize, path: let path):
            return "/t/p/\(imageSize.rawValue)\(path)"
        }
    }
    
    var urlParameters: [URLQueryItem]? {
        nil
    }
}
