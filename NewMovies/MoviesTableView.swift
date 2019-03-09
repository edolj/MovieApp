//
//  MoviesTableView.swift
//  NewMovies
//
//  Created by Edo Ljubijankic on 26/02/2018.
//  Copyright © 2018 Edo Ljubijankic. All rights reserved.
//

import UIKit

class MoviesTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var movie: MovieModel?
    var movies: [MovieModel] = []
    
    func setup() {
        delegate = self
        dataSource = self
        backgroundColor = UIColor.init(red: 31/255, green: 33/255, blue: 36/255, alpha: 1.0)
    }
    
    func searchDatabase(inputText: String) {
        // to clear table cell data for new input
        movies.removeAll()
        
        // to clear table cells
        reloadData()
        
        // search for movies
        parseData(key: inputText)
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
                            if let jsonFile = try JSONSerialization.jsonObject(with: content,
                                options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary,
                                let search = jsonFile["Search"] as? [NSDictionary] {
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
            self.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.dequeueReusableCell(withIdentifier: "idCell", for: indexPath) as? MovieTableViewCell
            else {
                return UITableViewCell()
        }
        
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
        self.deselectRow(at: indexPath, animated: true)
    }
}
