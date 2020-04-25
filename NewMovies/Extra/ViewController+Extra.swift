//
//  ViewController+Extra.swift
//  NewMovies
//
//  Created by Edo on 25/04/2020.
//  Copyright © 2020 Edo Ljubijankic. All rights reserved.
//

import UIKit

extension UIViewController {
    func styleNavigationController() {
        let isTranslucent = true
        if isTranslucent {
            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_gradient"), for: .default)
        }
        navigationController?.navigationBar.isTranslucent = isTranslucent
    }
}
