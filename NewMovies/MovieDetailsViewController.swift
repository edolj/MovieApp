//
//  MovieDetailsViewController.swift
//  NewMovies
//
//  Created by Edo Ljubijankic on 26/02/2018.
//  Copyright © 2018 Edo Ljubijankic. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var shareButton: TextUnderImageButton!
    @IBOutlet weak var posterDetails: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var ratingDetails: UIButton!
    @IBOutlet weak var actorsDetails: UILabel!
    @IBOutlet weak var directorDetails: UILabel!
    @IBOutlet weak var plotDetails: UITextView!
    @IBOutlet weak var langDetails: UILabel!
    
    var movieModel: MovieModel?
    var movieDetailsModel: MovieDetailsModel?
    var imdbID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.background
        plotDetails.contentInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        
        shareButton.setTitle("share".localized, for: .normal)
        shareButton.addTarget(self, action: #selector(shareData), for: .touchUpInside)
        
        playButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        
        loadMovieDetails(movieName: movieModel?.name)
    }
    
    public func loadMovieDetails(movieName: String?) {
        guard let movieName = movieName else {
            return
        }
        
        let movieTitle = movieName.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        let urlApi = String(format: "http://www.omdbapi.com/?apikey=%@&t=%@", ApiKey.imdb, movieTitle)
        let url = URL(string: urlApi)
        
        setupURLSession(url: url)
    }
    
    func setupURLSession(url: URL?) {
        guard let url = url else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let jsonFile = try JSONSerialization.jsonObject(with: data ?? Data(),
                                                                   options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary {
                    self.movieDetailsModel = MovieDetailsModel(dictionary: jsonFile)
                    self.imdbID = self.movieDetailsModel?.imdbID
                    self.imdbID.map {
                        YoutubeUrlRetriever.getYoutubeURL(imdbID: $0)
                    }
                }
                
                DispatchQueue.main.async {
                    self.setupData()
                }
            } catch {
                print("Error in parsing data from JSON.")
            }
        }
        task.resume()
    }
                    
    func setupData() {
        guard let viewModel = movieDetailsModel else {
            return
        }
        
        navigationItem.title = viewModel.title

        var infoText: [String] = []
        let separator = " | "
        if let runtime = viewModel.runtime {
            infoText.append(runtime)
            infoText.append(separator)
        }

        if let genre = viewModel.genre {
            infoText.append(genre)
            infoText.append(separator)
        }

        if let year = viewModel.year {
            infoText.append(year)
        }

        if infoText.count == 0 {
            infoLabel.isHidden = true
        } else {
            infoLabel.text = infoText.joined()
        }

        if let actors = viewModel.actors {
            actorsDetails.text = "actors_label".localized + actors
        } else {
            actorsDetails.isHidden = true
        }

        if let director = viewModel.director {
            directorDetails.text = "director_label".localized + director
        } else {
            directorDetails.isHidden = true
        }

        if let lang = viewModel.language {
            langDetails.text = "language_label".localized + lang
        } else {
            langDetails.isHidden = true
        }

        if let imdbRating = viewModel.rating {
            ratingDetails.setTitle(imdbRating, for: .normal)
        } else {
            ratingDetails.isHidden = true
        }

        plotDetails.text = viewModel.plot

        let imageUrl = viewModel.poster ?? "missing_image"
        if let url = URL(string: imageUrl),
            let data = try? Data(contentsOf: url) {
            posterDetails.image = UIImage(data: data)
        } else {
            posterDetails.image = UIImage(named: "missing_image")
        }
    }
    
    @objc func shareData() {
        guard let keyID = YoutubeUrlRetriever.keyID else {
            let items = [movieDetailsModel?.plot ?? ""]
            let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
            activityController.setValue(movieModel?.name, forKey: "Subject")
            present(activityController, animated: true)
            return
        }
        
        let items = [URL(string: "https://www.youtube.com/watch?v=\(keyID)")!]
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityController.setValue(movieModel?.name, forKey: "Subject")
        present(activityController, animated: true)
    }
    
    @objc func playVideo() {
        guard let keyID = YoutubeUrlRetriever.keyID else {
            let alert = UIAlertController(title: "alert".localized, message: "noVideo".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        navigate(from: self, to: .webViewController, data: URL(string: "https://www.youtube.com/watch?v=\(keyID)"))
    }

    deinit {
        YoutubeUrlRetriever.keyID = nil
        print("--class MovieDetailsViewController--")
    }
 }
