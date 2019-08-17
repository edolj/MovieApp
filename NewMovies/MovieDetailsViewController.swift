//
//  MovieDetailsViewController.swift
//  NewMovies
//
//  Created by Edo Ljubijankic on 26/02/2018.
//  Copyright © 2018 Edo Ljubijankic. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

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
    
    var movieModel: MovieModel?
    var movieDetailsModel: MovieDetailsModel?
    var imdbID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plotDetails.contentInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        
        trailerButton.backgroundColor = .yellow
        trailerButton.layer.cornerRadius = 5
        
        if let movie = movieModel {
            loadMovieDetails(movieName: movie.name)
        }
    }
    
    public func loadMovieDetails(movieName: String) {
        let movieTitle = movieName.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        let urlApi = "http://www.omdbapi.com/?apikey=482d09e9&t=" + movieTitle
        
        if let url = URL(string: urlApi) {
           let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Error with URLSession.")
            } else {
                if let content = data {
                    do {
                        if let jsonFile = try JSONSerialization.jsonObject(with: content,
                            options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary {
                        
                            self.movieDetailsModel = MovieDetailsModel(dictionary: jsonFile)
                            self.imdbID = self.movieDetailsModel?.imdb
                        }
                        
                        DispatchQueue.main.async {
                            if let movieDetailModel = self.movieDetailsModel {
                                self.navigationItem.title = movieDetailModel.title
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
    }
    
    @IBAction func showTrailerButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "VideoViewController")
            as? VideoViewController {
            controller.imdbID = imdbID
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    deinit {
        print("--class MovieDetailsViewController--")
    }
 }
