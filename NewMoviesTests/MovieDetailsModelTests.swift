//
//  MovieDetailsModelTests.swift
//  NewMoviesTests
//
//  Created by Edo Ljubijankic on 22/09/2019.
//  Copyright © 2019 Edo Ljubijankic. All rights reserved.
//

import XCTest
@testable import NewMovies

class MovieDetailsModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewModel1() {
        let dictionary: NSDictionary =
            ["Title": "Avengers",
             "Plot": "Heroes saving world.",
             "imdbRating": "8.0",
             "Year": "2012"]
        
        let viewModel = MovieDetailsModel(dictionary: dictionary)
        XCTAssertEqual(viewModel.title, "Avengers")
        XCTAssertEqual(viewModel.year, "2012")
        XCTAssertEqual(viewModel.director, "N/A")
        XCTAssertEqual(viewModel.actors, "N/A")
        XCTAssertEqual(viewModel.genre, "N/A")
        XCTAssertEqual(viewModel.imdb, "N/A")
    }

    func testViewModel2() {
        let dictionary: NSDictionary = [:]
        
        let viewModel = MovieDetailsModel(dictionary: dictionary)
        XCTAssertEqual(viewModel.genre, "N/A")
        XCTAssertEqual(viewModel.imdb, "N/A")
    }
    
}
