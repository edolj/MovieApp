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
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "search_title".localized
        view.backgroundColor = Color.background
        styleNavigationController()
        
        tableView.setup()
        tableView.protocolDelegate = self
        
        searchField.delegate = self
        searchField.becomeFirstResponder()
        
        findButton.setTitle("search_title".localized, for: .normal)
        findButton.addTarget(self, action: #selector(startSearch), for: .touchUpInside)
        findButton.backgroundColor = .green
        findButton.layer.cornerRadius = 5
    }
    
    @objc func startSearch() {
        if let userInput = searchField.text,
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
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController {
            detailsVC.movieModel = movieModel
            view.window?.endEditing(true)
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        startSearch()
        return true
    }
}
