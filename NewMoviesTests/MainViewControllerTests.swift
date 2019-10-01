//
//  MainViewControllerTests.swift
//  NewMoviesTests
//
//  Created by Edo Ljubijankic on 01/10/2019.
//  Copyright © 2019 Edo Ljubijankic. All rights reserved.
//

import XCTest
@testable import NewMovies

class MainViewControllerTests: XCTestCase {
    
    var vc: MainViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        vc = viewController
        _ = vc.view // to call viewDidLoad
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearch() {
        vc.titleField.text = "batman"
        XCTAssertEqual(vc.titleField.text, "batman")

        vc.startSearch()
        sleep(5) // wait for loading table with data
        XCTAssertEqual(vc.tableView.movies.count, 10)
    }

}
