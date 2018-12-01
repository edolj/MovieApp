//
//  ViewController.swift
//  NewMovies
//
//  Created by Edo Ljubijankic on 26/02/2018.
//  Copyright © 2018 Edo Ljubijankic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: MoviesTableView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    
    var movie:Movie?
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = UIColor.init(red: 31/255, green: 33/255, blue: 36/255, alpha: 1.0)
        findButton.backgroundColor = .yellow
        findButton.layer.cornerRadius = 5
        titleField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        tableView.reloadData()
        // table cells empty
        if titleField.text?.isEmpty ?? true {
            print("is empty")
        } else {
            if let searchMovie = titleField.text {
                parseData(key: searchMovie)
            }
        }
    }
    
    func parseData(key: String) {
        let removeSpaces = key.trimmingCharacters(in: .whitespacesAndNewlines)
        let modifySearch = removeSpaces.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        
        let connectUrl = "http://www.omdbapi.com/?apikey=482d09e9&s="+modifySearch
        let url = URL(string: connectUrl)
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
                        
                        if let search = myJson["Search"] as? [NSDictionary]
                        {
                            for result in search {
                                //print(result["Title"]!)
                                //print(result["Year"]!)
                                
                                self.movies.append(Movie(name: result["Title"]! as! String, year: result["Year"]! as! String))
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! MovieDetailsViewController
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
        cell.movieName.text = row.name + " ( " + row.year + " ) "
        
        return cell
    }

}

