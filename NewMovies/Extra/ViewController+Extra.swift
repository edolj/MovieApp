//
//  ViewController+Extra.swift
//  NewMovies
//
//  Created by Edo on 25/04/2020.
//  Copyright © 2020 Edo Ljubijankic. All rights reserved.
//

import UIKit

enum DestinationViewController {
    case detailsViewController
}

extension UIViewController {
    func navigate(from vc: UIViewController, to destinationController: DestinationViewController, data: Any?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC: UIViewController
        
        switch destinationController {
        case .detailsViewController:
            destinationVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController")
            if let movieModel = data as? MovieModel,
                let vc = destinationVC as? MovieDetailsViewController {
                vc.movieModel = movieModel
            }
        }
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func styleNavigationController() {
        let isTranslucent = true
        if isTranslucent {
            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_gradient"), for: .default)
        }
        navigationController?.navigationBar.isTranslucent = isTranslucent
    }
}
