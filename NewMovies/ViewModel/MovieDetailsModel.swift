//
//  MovieDetails.swift
//  NewMovies
//
//  Created by Edo Ljubijankic on 27/02/2018.
//  Copyright © 2018 Edo Ljubijankic. All rights reserved.
//

import UIKit

class MovieDetailsModel {

    let title: String?
    let year: String?
    let rating: String?
    let runtime: String?
    let genre: String?
    let director: String?
    let writer: String?
    let actors: String?
    let plot: String?
    let language: String?
    let poster: String?
    let imdbID: String?
    
    init(dictionary: NSDictionary) {
        self.title = dictionary["Title"] as? String
        self.plot = dictionary["Plot"] as? String
        self.rating = dictionary["imdbRating"] as? String
        self.year = dictionary["Year"] as? String
        self.runtime = dictionary["Runtime"] as? String
        self.genre = dictionary["Genre"] as? String
        self.director = dictionary["Director"] as? String
        self.writer = dictionary["Writer"] as? String
        self.actors = dictionary["Actors"] as? String
        self.language = dictionary["Language"] as? String
        self.poster = dictionary["Poster"] as? String
        self.imdbID = dictionary["imdbID"] as? String
    }

}
