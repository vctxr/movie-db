//
//  MovieListViewModelTest.swift
//  MovieDBTests
//
//  Created by Victor Samuel Cuaca on 15/12/20.
//

import XCTest
@testable import MovieDB

class MovieListViewModelTest: XCTestCase {
    
    var movieListViewModel: MovieListViewModel!

    override func setUp() {
        movieListViewModel = MovieListViewModel(movieDBAPI: MovieDBAPI())
    }
    
    override func tearDown() {
        movieListViewModel = nil
    }

    func testCanFetchPopular() {
        let expectation = self.expectation(description: "fetchMovies")
        movieListViewModel.fetchMovies(endpoint: .popular) { [self] error in
            expectation.fulfill()
            if error == nil {
                XCTAssert(movieListViewModel.movieViewModels.count > 0)
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(movieListViewModel.isShowingPlaceholder, false)
    }
    
    func testCanFetchTopRated() {
        let expectation = self.expectation(description: "fetchMovies")
        movieListViewModel.fetchMovies(endpoint: .topRated) { [self] error in
            expectation.fulfill()
            if error == nil {
                XCTAssert(movieListViewModel.movieViewModels.count > 0)
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(movieListViewModel.isShowingPlaceholder, false)
    }
    
    func testCanFetchUpcoming() {
        let expectation = self.expectation(description: "fetchMovies")
        movieListViewModel.fetchMovies(endpoint: .upcoming) { [self] error in
            expectation.fulfill()
            if error == nil {
                XCTAssert(movieListViewModel.movieViewModels.count > 0)
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(movieListViewModel.isShowingPlaceholder, false)
    }
    
    func testCanFetchNowPlaying() {
        let expectation = self.expectation(description: "fetchMovies")
        movieListViewModel.fetchMovies(endpoint: .nowPlaying) { [self] error in
            expectation.fulfill()
            if error == nil {
                XCTAssert(movieListViewModel.movieViewModels.count > 0)
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(movieListViewModel.isShowingPlaceholder, false)
    }
}
