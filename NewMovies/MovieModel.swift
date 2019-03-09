//
//  Movie.swift
//  NewMovies
//
//  Created by Edo Ljubijankic on 26/02/2018.
//  Copyright © 2018 Edo Ljubijankic. All rights reserved.
//

import UIKit

class MovieModel {

    let name: String
    let year: String
    let poster: String
    
    init(name: String, year: String, poster: String) {
        self.name = name
        self.year = year
        self.poster = poster
    }
}
