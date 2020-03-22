//
//  String+Extra.swift
//  NewMovies
//
//  Created by Edo on 22/03/2020.
//  Copyright © 2020 Edo Ljubijankic. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
