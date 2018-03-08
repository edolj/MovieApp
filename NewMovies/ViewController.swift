//
//  ViewController.swift
//  NewMovies
//
//  Created by Edo Ljubijankic on 26/02/2018.
//  Copyright © 2018 Edo Ljubijankic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: MoviesTableView!
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    
    var movie:Movie?
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func findMovie(_ sender: UIButton) {
        //print(titleField.text! + " " + yearField.text!)
    
        if titleField.text?.isEmpty ?? true {
            print("is empty")
        } else {
            
        
        //let movie1 = Movie(name: "It", year: "2017")
        //let movie2 = Movie(name: "Town", year: "2010")
        //let newMovie = Movie(name: titleField.text!, year: yearField.text!)
        //movies += [movie1,movie2,newMovie]
        //movies.append(newMovie)
        
        let searchMovie = titleField.text!
        let removeSpaces = searchMovie.trimmingCharacters(in: .whitespacesAndNewlines)
        let modifySearch = removeSpaces.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        //print(modifySearch)
            
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.reloadData()
        }
            
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

