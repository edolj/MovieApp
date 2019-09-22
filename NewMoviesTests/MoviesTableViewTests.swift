//
//  MoviesTableViewTests.swift
//  NewMoviesTests
//
//  Created by Edo Ljubijankic on 22/09/2019.
//  Copyright © 2019 Edo Ljubijankic. All rights reserved.
//

import XCTest
@testable import NewMovies

class MoviesTableViewTests: XCTestCase {

    let tableView = MoviesTableView()
    var session: URLSession!

    override func setUp() {
      super.setUp()
      session = URLSession(configuration: .default)
    }

    override func tearDown() {
      session = nil
      super.tearDown()
    }

    func testTableWithViewModel() {
        tableView.searchDatabase(inputText: "batman")
        let url = URL(string: "http://www.omdbapi.com/?apikey=482d09e9&s=batman")
        
        let promise = expectation(description: "Status code: 200")
        let dataTask = session.dataTask(with: url!) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
        XCTAssertEqual(tableView.movies.count, 10)
    }
    
}
