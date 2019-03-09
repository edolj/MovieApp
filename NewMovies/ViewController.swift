//
//  ViewController.swift
//  NewMovies
//
//  Created by Edo Ljubijankic on 26/02/2018.
//  Copyright © 2018 Edo Ljubijankic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: MoviesTableView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.setup()
        
        titleField.delegate = self
        titleField.becomeFirstResponder()
        
        findButton.backgroundColor = .yellow
        findButton.layer.cornerRadius = 5
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleField.resignFirstResponder()
        startSearch()
        return true
    }
    
    @IBAction func findMovie(_ sender: UIButton) {
        startSearch()
    }
    
    func startSearch() {
        if let userInput = titleField.text, userInput.count > 0 {
            tableView.searchDatabase(inputText: userInput)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let indexPath = tableView.indexPathForSelectedRow,
                let controller = segue.destination as? MovieDetailsViewController {
                    controller.getMovie = tableView.movies[indexPath.row]
            }
        }
    }
}

