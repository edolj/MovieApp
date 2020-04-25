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
    
    init(dictionary: NSDictionary) {
        self.name = (dictionary["Title"] as? String) ?? ""
        self.year = (dictionary["Year"] as? String) ?? ""
        self.poster = (dictionary["Poster"] as? String) ?? ""
    }
}
