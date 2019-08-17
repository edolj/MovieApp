//
//  MainViewController.swift
//  NewMovies
//
//  Created by Edo Ljubijankic on 26/02/2018.
//  Copyright © 2018 Edo Ljubijankic. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: MoviesTableView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search"
        
        tableView.setup()
        tableView.protocolDelegate = self
        
        titleField.delegate = self
        titleField.becomeFirstResponder()
        
        findButton.backgroundColor = .yellow
        findButton.layer.cornerRadius = 5
    }
    
    @IBAction func findMovie(_ sender: UIButton) {
        startSearch()
    }
    
    func startSearch() {
        if let userInput = titleField.text,
           userInput.count > 0 {
            tableView.searchDatabase(inputText: userInput)
        }
    }

    deinit {
        print("--class MainViewController--")
    }
}

extension MainViewController: SelecetedMovieDelegate {
    func didSelectItem(movieModel: MovieModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController")
            as? MovieDetailsViewController {
            detailVC.movieModel = movieModel
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleField.resignFirstResponder()
        startSearch()
        return true
    }
}
