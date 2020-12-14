//
//  MovieDBAPI.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 13/12/20.
//

import Foundation

class MovieDBAPI: APICaller {
    
    var task: URLSessionDataTask?
        
    func fetch<T: Decodable>(with endpoint: MovieDBEndpoint, completion: @escaping (Result<T, APIError>) -> Void) {
        let request = endpoint.urlRequest
        print("Requesting with url: \(request)")
        get(with: &task, request: request, completion: completion)
    }
}
