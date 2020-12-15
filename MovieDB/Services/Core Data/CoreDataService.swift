//
//  CoreDataService.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 15/12/20.
//

import UIKit
import CoreData

struct CoreDataService: CoreDataInteractor {
    
    func saveMovie(viewModel: MovieViewModel) throws {
        let movie = Movie(context: viewContext)
        movie.id = Int64(viewModel.id)
        movie.imagePath = viewModel.imagePath
        movie.title = viewModel.title
        movie.releaseDate = viewModel.releaseDate
        movie.overview = viewModel.overview
        movie.popularity = viewModel.popularity
        movie.voteAverage = viewModel.voteAverage
        movie.createdAt = Date()
        
        try viewContext.save()
    }
    
    func fetchMovies() -> [Movie] {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sort]

        do {
            let movies = try viewContext.fetch(request)
            return movies
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func deleteMovie(id: Int) throws {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        let predicate = NSPredicate(format: "id == %i", id)
        request.predicate = predicate
        request.fetchLimit = 1
        
        guard let movie = try viewContext.fetch(request).first else { return }
        viewContext.delete(movie)
        
        try viewContext.save()
    }
}

