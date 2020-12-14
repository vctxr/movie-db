//
//  MenuOption.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 13/12/20.
//

import Foundation

struct MenuOption {
    let title: String
    let category: Category
    
    static let allOptions = [
        MenuOption(title: "Popular", category: .popular),
        MenuOption(title: "Upcoming", category: .upcoming),
        MenuOption(title: "Top Rated", category: .topRated),
        MenuOption(title: "Now Playing", category: .nowPlaying)
    ]
}

enum Category: String, CaseIterable {
    case popular
    case upcoming
    case topRated
    case nowPlaying
}
