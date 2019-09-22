//
//  MovieTableViewCellTests.swift
//  NewMoviesTests
//
//  Created by Edo Ljubijankic on 22/09/2019.
//  Copyright © 2019 Edo Ljubijankic. All rights reserved.
//

import XCTest
@testable import NewMovies

class MovieTableViewCellTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCell() {
        let bundle = Bundle(for: MovieTableViewCell.self)
        guard let cell = bundle.loadNibNamed("MovieTableViewCell", owner: nil)?.first as? MovieTableViewCell else {
            return XCTFail("Cell is not initialized.")
         }
        
        let dictionary: NSDictionary =
            ["Title": "Avengers",
             "Year": "2012",
             "Poster": ""]
        
        let viewModel = MovieModel(dictionary: dictionary)
        cell.setup(viewModel: viewModel)
        
        XCTAssertEqual(cell.movieName.text, viewModel.name + " ( " + viewModel.year + " ) ")
    }
    
}
