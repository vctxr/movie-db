//
//  ImageCacher.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 13/12/20.
//

import Foundation

/// A shared cache to store  images
final class ImageCacher {
    
    static let shared = ImageCacher()
    
    private init() {}
    
    let imageCache = NSCache<NSString, NSData>()
}
