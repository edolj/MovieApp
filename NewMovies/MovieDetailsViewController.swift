//
//  MovieDetailsViewController.swift
//  NewMovies
//
//  Created by Edo Ljubijankic on 26/02/2018.
//  Copyright © 2018 Edo Ljubijankic. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var titleDetails: UILabel!
    @IBOutlet weak var posterDetails: UIImageView!
    @IBOutlet weak var ratingDetails: UILabel!
    @IBOutlet weak var actorsDetails: UILabel!
    @IBOutlet weak var directorDetails: UILabel!
    @IBOutlet weak var plotDetails: UITextView!
    @IBOutlet weak var runtimeDetails: UILabel!
    @IBOutlet weak var yearDetails: UILabel!
    @IBOutlet weak var genreDetails: UILabel!
    @IBOutlet weak var releaseDetails: UILabel!
    @IBOutlet weak var langDetails: UILabel!
    @IBOutlet weak var trailerButton: UIButton!
    
    var getMovie: MovieModel?
    var movieDetails: MovieDetailsModel?
    var imdbID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plotDetails.contentInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        
        trailerButton.backgroundColor = .yellow
        trailerButton.layer.cornerRadius = 5
        
        loadMovieDetails()
    }
    
    public func loadMovieDetails() {
        guard let movie = getMovie else {
            return
        }

        let movieName = movie.name.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        let urlApi = "http://www.omdbapi.com/?apikey=482d09e9&t="+movieName
        
        guard let url = URL(string: urlApi) else {
            titleDetails.text = "Movie NOT found in our database! Return back."
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Error with URLSession.")
            } else {
                if let content = data {
                    do {
                        if let jsonFile = try JSONSerialization.jsonObject(with: content,
                            options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary {
                        
                            self.movieDetails = MovieDetailsModel(dictionary: jsonFile)
                            self.imdbID = self.movieDetails?.imdb
                        }
                        
                        DispatchQueue.main.async {
                            if let movieDetailModel = self.movieDetails {
                                self.titleDetails.text = movieDetailModel.title
                                self.plotDetails.text = movieDetailModel.plot
                                self.ratingDetails.text = "IMDB Rating: " + movieDetailModel.rating
                                self.actorsDetails.text = "Actors: " + movieDetailModel.actors
                                self.directorDetails.text = "Director: " + movieDetailModel.director
                                self.yearDetails.text = "Year: " + movieDetailModel.year
                                self.releaseDetails.text = "Released: " + movieDetailModel.released
                                self.runtimeDetails.text = "Runtime: " + movieDetailModel.runtime
                                self.genreDetails.text = "Genre: " + movieDetailModel.genre
                                self.langDetails.text = "Language: " + movieDetailModel.language
                                
                                let imageUrl = movieDetailModel.poster
                                if let url = URL(string: imageUrl),
                                   let data = try? Data(contentsOf: url) {
                                        self.posterDetails.image = UIImage(data: data)
                                    } else {
                                        self.posterDetails.image = UIImage(named: "missing_image")
                                    }
                            }
                        }
                        
                    } catch {
                        print("Error in parsing data from JSON.")
                    }
                }
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTrailer",
            let controller = segue.destination as? VideoViewController {
            controller.imdbID = imdbID
        }
    }

 }
