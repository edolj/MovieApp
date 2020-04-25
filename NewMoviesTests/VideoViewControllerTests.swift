//
//  VideoViewControllerTests.swift
//  NewMoviesTests
//
//  Created by Edo Ljubijankic on 01/10/2019.
//  Copyright © 2019 Edo Ljubijankic. All rights reserved.
//

import XCTest
@testable import NewMovies

class VideoViewControllerTests: XCTestCase {

    var vc: VideoViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        vc = viewController
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testVideo() {
        vc.imdbID = "tt0372784"
        _ = vc.view // call viewDidLoad
        
        sleep(1) // wait on request to get keyID
        XCTAssertNotNil(vc.keyID)
    }
}
