//
//  APICaller.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 13/12/20.
//

import Foundation

enum APIError: Error {
    case noConnection
    case badData
    case badResponse(message: String)
    case failedToDecode
    case canceled
    case unknown(errorCode: Int, description: String)
}

protocol APICaller {
    var task: URLSessionDataTask? { get set }
    func get<T: Decodable>(with task: inout URLSessionDataTask?, request: URLRequest, completion: @escaping (Result<T, APIError>) -> Void)
}

extension APICaller {
    
    func get<T: Decodable>(with task: inout URLSessionDataTask?, request: URLRequest, completion: @escaping (Result<T, APIError>) -> Void) {
        task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                switch error._code {
                case -999:
                    return completion(.failure(.canceled))
                case -1009:
                    return completion(.failure(.noConnection))
                default:
                    return completion(.failure(.unknown(errorCode: error._code, description: error.localizedDescription)))
                }
            }
            
            guard let data = data else {
                return completion(.failure(.badData))
            }
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                let message = String(decoding: data, as: UTF8.self)
                completion(.failure(.badResponse(message: message)))
                return
            }
            
            guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(.failedToDecode))
                return
            }
                                                            
            completion(.success(decodedData))
        }
        task!.resume()
    }
}
