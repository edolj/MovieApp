//
//  MovieDetailsViewControllerTests.swift
//  NewMoviesTests
//
//  Created by Edo Ljubijankic on 01/10/2019.
//  Copyright © 2019 Edo Ljubijankic. All rights reserved.
//

import XCTest
@testable import NewMovies

class MovieDetailsViewControllerTests: XCTestCase {

    var vc: MovieDetailsViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        vc = viewController
        _ = vc.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadData() {
        vc.loadMovieDetails(movieName: "batman")
        sleep(5) // wait for main thread while loading data
        XCTAssertEqual(vc.imdbID, vc.movieDetailsModel?.imdb)
    }

}
