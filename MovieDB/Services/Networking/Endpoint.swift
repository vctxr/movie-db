//
//  Endpoint.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 13/12/20.
//

import Foundation

protocol Endpoint {
    var baseUrl: String { get }
    var path: String { get }
    var urlParameters: [URLQueryItem]? { get }
}

extension Endpoint {
    
    var urlCompononents: URLComponents {
        var urlCompononents = URLComponents(string: baseUrl)
        urlCompononents?.path = path
        urlCompononents?.queryItems = urlParameters
        return urlCompononents!
    }
    
    var urlRequest: URLRequest {
        URLRequest(url: urlCompononents.url!)
    }
}
