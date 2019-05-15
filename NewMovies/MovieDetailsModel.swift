//
//  MovieDetails.swift
//  NewMovies
//
//  Created by Edo Ljubijankic on 27/02/2018.
//  Copyright © 2018 Edo Ljubijankic. All rights reserved.
//

import UIKit

class MovieDetailsModel {

    let title: String
    let year: String
    let rating: String
    let released: String
    let runtime: String
    let genre: String
    let director: String
    let writer: String
    let actors: String
    let plot: String
    let language: String
    let poster: String
    let imdb: String
    
    init(dictionary: NSDictionary) {
        self.title = (dictionary["Title"] as? String) ?? "N/A"
        self.plot = (dictionary["Plot"] as? String) ?? "N/A"
        self.rating = (dictionary["imdbRating"] as? String) ?? "N/A"
        self.year = (dictionary["Year"] as? String) ?? "N/A"
        self.released = (dictionary["Released"] as? String) ?? "N/A"
        self.runtime = (dictionary["Runtime"] as? String) ?? "N/A"
        self.genre = (dictionary["Genre"] as? String) ?? "N/A"
        self.director = (dictionary["Director"] as? String) ?? "N/A"
        self.writer = (dictionary["Writer"] as? String) ?? "N/A"
        self.actors = (dictionary["Actors"] as? String) ?? "N/A"
        self.language = (dictionary["Language"] as? String) ?? "N/A"
        self.poster = (dictionary["Poster"] as? String) ?? "N/A"
        self.imdb = (dictionary["imdbID"] as? String) ?? "N/A"
    }

}
