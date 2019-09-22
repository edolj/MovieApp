//
//  MovieModelTests.swift
//  NewMoviesTests
//
//  Created by Edo Ljubijankic on 22/09/2019.
//  Copyright © 2019 Edo Ljubijankic. All rights reserved.
//

import XCTest
@testable import NewMovies

class MovieModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewModel1() {
        let dictionary: NSDictionary =
            ["Title": "Avengers",
             "Year": "2012",
             "Poster": ""]
        
        let viewModel = MovieModel(dictionary: dictionary)
        XCTAssertEqual(viewModel.name, "Avengers")
        XCTAssertEqual(viewModel.year, "2012")
        XCTAssertEqual(viewModel.poster, "")
    }
    
    func testViewModel2() {
        let dictionary: NSDictionary = [:]
        
        let viewModel = MovieModel(dictionary: dictionary)
        XCTAssertEqual(viewModel.name, "")
        XCTAssertEqual(viewModel.year, "")
        XCTAssertEqual(viewModel.poster, "")
    }

}
