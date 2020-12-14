//
//  AsyncLoadedImageView.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 13/12/20.
//

import UIKit

final class AsyncLoadedImageView: UIImageView, Shimmerable {
    
    private var task: URLSessionTask!
    let gradientLayer = CAGradientLayer()
    
    /// Loads the image from cache, if doesnt exist then load image asynchronously
    /// - Parameter endpoint: ImageEndpoint representing the image endpoint
    func loadImage(endpoint: ImageEndpoint) {
        image = nil

        // Cancel any ongoing tasks
        if let task = task {
            task.cancel()
        }
        
        let request = endpoint.urlRequest
        guard let url = request.url else { return }
        
        if let cachedImageData = ImageCacher.shared.imageCache.object(forKey: url.absoluteString as NSString) {
            image = UIImage(data: cachedImageData as Data)
            return
        }
        
        animateShimmer(true)
        task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let imageData = data, let newImage = UIImage(data: imageData), error == nil else { return }
            
            ImageCacher.shared.imageCache.setObject(imageData as NSData, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async {
                self.animateShimmer(false)
                self.image = newImage
            }
        }
        task.resume()
    }
    
    init() {
        super.init(frame: .zero)
        configureShimmerGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
