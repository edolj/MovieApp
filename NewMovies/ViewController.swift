//
//  ViewController.swift
//  NewMovies
//
//  Created by Edo Ljubijankic on 26/02/2018.
//  Copyright © 2018 Edo Ljubijankic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: MoviesTableView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    
    var movie: MovieModel?
    var movies: [MovieModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.init(red: 31/255, green: 33/255, blue: 36/255, alpha: 1.0)
        
        titleField.delegate = self
        titleField.becomeFirstResponder()
        
        findButton.backgroundColor = .yellow
        findButton.layer.cornerRadius = 5
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleField.resignFirstResponder()
        searchDatabase()
        return true
    }
    
    @IBAction func findMovie(_ sender: UIButton) {
        searchDatabase()
    }
    
    func searchDatabase() {
        // to clear table cell data for new input
        movies.removeAll()

        // to clear table cells
        tableView.reloadData()

        // search for movies
        if let searchMovie = titleField.text {
            if searchMovie.count > 0 {
                parseData(key: searchMovie)
            }
        }
    }

    func parseData(key: String) {
        let removeSpaces = key.trimmingCharacters(in: .whitespacesAndNewlines)
        let modifySearch = removeSpaces.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)

        let connectUrl = "http://www.omdbapi.com/?apikey=482d09e9&s="+modifySearch
        if let url = URL(string: connectUrl) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Error with URLSession.")
                } else {
                    if let content = data {
                        do {
                            let jsonFile = try JSONSerialization.jsonObject(with: content,
                            options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary

                            if let search = jsonFile["Search"] as? [NSDictionary] {
                                for result in search {
                                    if let movieTitle = result["Title"] as? String,
                                       let movieYear = result["Year"] as? String,
                                       let movieposter = result["Poster"] as? String {

                                     self.movies.append(MovieModel(name: movieTitle,
                                                              year: movieYear,
                                                              poster: movieposter))
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

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let indexPath = tableView.indexPathForSelectedRow,
                let controller = segue.destination as? MovieDetailsViewController {
                    controller.getMovie = movies[indexPath.row]
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath) as! MovieTableViewCell
        let row = movies[indexPath.row]

        if let urlToPoster = URL(string: row.poster),
            let data = try? Data(contentsOf: urlToPoster) {
                cell.moviePoster.image = UIImage(data: data)
            } else {
                cell.moviePoster.image = UIImage(named: "missing_image")
            }

        cell.movieName.text = row.name + " ( " + row.year + " ) "

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

