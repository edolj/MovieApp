//
//  MoviesTableView.swift
//  NewMovies
//
//  Created by Edo Ljubijankic on 26/02/2018.
//  Copyright © 2018 Edo Ljubijankic. All rights reserved.
//

import UIKit

protocol SelecetedMovieDelegate: class {
    func didSelectItem(movie: MovieModel)
}

class MoviesTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var movie: MovieModel?
    var movies: [MovieModel] = []
    weak var protocolDelegate: SelecetedMovieDelegate?
    
    func setup() {
        delegate = self
        dataSource = self
        
        register(UINib.init(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
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
                                    self.movies = search.map({ MovieModel(dictionary: $0) })
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath)

        if let cell = cell as? MovieTableViewCell {
            let viewModel = movies[indexPath.row]
            cell.setup(viewModel: viewModel)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.deselectRow(at: indexPath, animated: true)
        
        let viewModel = movies[indexPath.row]
        protocolDelegate?.didSelectItem(movie: viewModel)
    }
}
