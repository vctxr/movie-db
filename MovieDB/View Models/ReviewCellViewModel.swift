//
//  ReviewCellViewModel.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 14/12/20.
//

import Foundation

struct ReviewCellViewModel {
    
    let authorName: String
    let username: String
    let avatarPath: String?
    let content: String
    let createdAt: String
    
    init(reviewResult: ReviewResult) {
        authorName = reviewResult.authorDetails.name.isEmpty ? "--" : reviewResult.authorDetails.name
        username = "@\(reviewResult.authorDetails.username)"
        avatarPath = reviewResult.authorDetails.avatarPath
        content = reviewResult.content
        createdAt = reviewResult.createdAt
    }
}
