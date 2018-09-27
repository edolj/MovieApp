//
//  MovieDetails.swift
//  NewMovies
//
//  Created by Edo Ljubijankic on 27/02/2018.
//  Copyright © 2018 Edo Ljubijankic. All rights reserved.
//

import UIKit

class MovieDetails {

    let title:String
    let year:String
    let rated:String
    let released:String
    let runtime:String
    let genre:String
    let director:String
    let writer:String
    let actors:String
    let plot:String
    let language:String
    let poster:String
    
    init(title:String, year:String, rated:String, released:String, runtime:String, genre:String, director:String, writer:String, actors:String, plot:String, language:String, poster:String) {
        self.title = title
        self.year = year
        self.rated = rated
        self.released = released
        self.runtime = runtime
        self.genre = genre
        self.director = director
        self.writer = writer
        self.actors = actors
        self.plot = plot
        self.language = language
        self.poster = poster
    }
}
