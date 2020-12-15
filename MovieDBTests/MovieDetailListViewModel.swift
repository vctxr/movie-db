//
//  MovieDetailListViewModelTest.swift
//  MovieDBTests
//
//  Created by Victor Samuel Cuaca on 15/12/20.
//

import XCTest
@testable import MovieDB


class MovieDetailListViewModelTest: XCTestCase {

    var movieDetailListViewModel: MovieDetailListViewModel!

    override func setUp() {
        movieDetailListViewModel = MovieDetailListViewModel(movieDBAPI: MovieDBAPI(),
                                                            coreDataService: CoreDataService(),
                                                            movieViewModel: MovieViewModel(movie: MovieResult(adult: false, backdropPath: "/ndlQ2Cuc3cjTL7lTynw6I4boP4S.jpg", genreIDS: [14, 28, 80], id: 297761, originalLanguage: "en", originalTitle: "Suicide Squad", overview: "From DC Comics comes the Suicide Squad, an antihero team of incarcerated supervillains who act as deniable assets for the United States government, undertaking high-risk black ops missions in exchange for commuted prison sentences.", popularity: 48.261451, posterPath: "/e1mjopzAS2KNsvpbpahQ1a6SkSn.jpg", releaseDate: "2016-08-03", title: "Suicide Squad", video: false, voteAverage: 5.25, voteCount: 1466)))
    }
    
    override func tearDown() {
        movieDetailListViewModel = nil
    }
    
    func testCanFetchReviews() {
        let expectation = self.expectation(description: "fetchReviews")
        movieDetailListViewModel.fetchReviews() { [self] error in
            expectation.fulfill()
            if error == nil {
                XCTAssert(movieDetailListViewModel.reviewViewModels.count > 0)
            }
        }
        XCTAssertEqual(movieDetailListViewModel.isFetchingReviews, true)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(movieDetailListViewModel.isFetchingReviews, false)
    }
    
    func testCanFetchDetails() {
        let expectation = self.expectation(description: "fetchDetails")
        movieDetailListViewModel.fetchDetails() { [self] error in
            expectation.fulfill()
            if error == nil {
                XCTAssert(movieDetailListViewModel.fetchDetailError == nil)
                XCTAssert(movieDetailListViewModel.movieDetailViewModel != nil)
            } else {
                XCTAssert(movieDetailListViewModel.fetchDetailError != nil)
            }
        }
        XCTAssertEqual(movieDetailListViewModel.isFetchingDetails, true)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(movieDetailListViewModel.isFetchingDetails, false)
    }
}
