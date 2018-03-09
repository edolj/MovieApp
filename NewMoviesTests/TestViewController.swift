//
//  TestViewController.swift
//  NewMoviesTests
//
//  Created by Edo Ljubijankic on 08/03/2018.
//  Copyright © 2018 Edo Ljubijankic. All rights reserved.
//

import XCTest
@testable import NewMovies

class TestViewController: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParseData() {
        let viewController = ViewController()
        let table: MoviesTableView!
        
        let movies = [Movie(name:"Batman",year: "1989"),Movie(name: "Dunkirk",year:"2017"),Movie(name:"It",year:"2017")]
        
        let title = "It"
        viewController.parseData(key: title)
        
        //let _ = viewController.view
        XCTAssert(viewController.tableView(table, cellForRowAt: 2).movieName.text == title)
    }
    
}
