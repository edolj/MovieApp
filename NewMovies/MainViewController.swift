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
        searchField.textColor = .black
        searchField.tintColor = .black
        
        findButton.setTitle("search_title".localized, for: .normal)
        findButton.addTarget(self, action: #selector(startSearch), for: .touchUpInside)
        findButton.backgroundColor = .green
        findButton.layer.cornerRadius = 5
    }
    
    @objc func startSearch() {
        view.window?.endEditing(true)
        
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
        navigate(from: self, to: .detailsViewController, data: movieModel)
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        startSearch()
        return true
    }
}
