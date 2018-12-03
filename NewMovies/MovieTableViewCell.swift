//
//  MovieTableViewCell.swift
//  NewMovies
//
//  Created by Edo Ljubijankic on 26/02/2018.
//  Copyright © 2018 Edo Ljubijankic. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        movieName.textColor = .white
    }
}
