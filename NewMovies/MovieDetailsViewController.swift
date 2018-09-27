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
//    @IBOutlet weak var trailerButton: UIButton!
    
    var getMovie: Movie?
    var movieDetails: MovieDetails?
    var imdbID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMovieDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func loadMovieDetails() {
        let movieName = getMovie!.name.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        
        let urlApi = "http://www.omdbapi.com/?apikey=482d09e9&t="+movieName
        let url = URL(string: urlApi)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil
            {
                print("error")
            }
            else
            {
                if let content = data
                {
                    do
                    {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                        
                        let title = String(describing: myJson["Title"]!)
                        let plot = String(describing: myJson["Plot"]!)
                        let rating = String(describing: myJson["imdbRating"]!)
                        let year = String(describing: myJson["Year"]!)
                        let released = String(describing: myJson["Released"]!)
                        let runtime = String(describing: myJson["Runtime"]!)
                        let genre = String(describing: myJson["Genre"]!)
                        let director = String(describing: myJson["Director"]!)
                        let writer = String(describing: myJson["Writer"]!)
                        let actors = String(describing: myJson["Actors"]!)
                        let lang = String(describing: myJson["Language"]!)
                        let image = String(describing: myJson["Poster"]!)
                        self.imdbID = String(describing: myJson["imdbID"]!)
                        
                        self.movieDetails = MovieDetails(title: title, year: year, rated: rating, released: released, runtime: runtime, genre: genre, director: director, writer: writer, actors: actors, plot: plot, language: lang, poster: image)
                        
                         DispatchQueue.main.async {
                            self.titleDetails.text = self.movieDetails!.title
                            self.plotDetails.text = self.movieDetails!.plot
                            self.ratingDetails.text = "IMDB Rating: " + self.movieDetails!.rated
                            self.actorsDetails.text = "Actors: " + self.movieDetails!.actors
                            self.directorDetails.text = "Director: " + self.movieDetails!.director
                            self.yearDetails.text = "Year: " + self.movieDetails!.year
                            self.releaseDetails.text = "Released: " + self.movieDetails!.released
                            self.runtimeDetails.text = "Runtime: " + self.movieDetails!.runtime
                            self.genreDetails.text = "Genre: " + self.movieDetails!.genre
                            self.langDetails.text = "Language: " + self.movieDetails!.language
                            
                            let imageUrl = self.movieDetails?.poster
                            if let image = imageUrl {
                                let url = URL(string: image)
                                let data = try? Data(contentsOf: url!)
                                self.posterDetails.image = UIImage(data: data!)
                            }
                        }
                    }
                    catch
                    {
                        print("error in JSONSerialization")
                    }
                }
            }
        }
        task.resume()
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTrailer" {
            let controller = segue.destination as! VideoViewController
            controller.imdbID = imdbID
        }
    }

 }
