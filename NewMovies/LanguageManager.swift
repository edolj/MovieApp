//
//  LanguageManager.swift
//  NewMovies
//
//  Created by Edo on 22/03/2020.
//  Copyright © 2020 Edo Ljubijankic. All rights reserved.
//

import Foundation

class LanguageManager {
    
    // MARK: - Properties
    static let shared = LanguageManager()
    private var _language: String?
    private var _bundle: Bundle?
    private(set) var loadedLocale: Locale?
    
    init() {
      setLanguage(language: Locale.current.languageCode!)
    }
    
    // MARK: - Public Methods
    
    /// Set default localisation langauge
    func setLanguage(language: String) {
        self._language = language
        
        if let path = Bundle.main.path(forResource: language, ofType: "lproj") {
            _bundle = Bundle(path: path)
            loadedLocale = Locale(identifier: language)
        }
        else {
        }
    }
    
    func getLanguage() -> String {
        return _language ?? "en"
    }
    
    /// Get bundle for current language
    func bundle() -> Bundle {
        // fallback to english in no language was set
        if _bundle == nil {
            setLanguage(language: "en")
        }
        return _bundle!
    }
    
    /// Get locale for current language
    func locale() -> Locale {
        if let loadedLocale = loadedLocale {
            return loadedLocale
        }
        return Locale.current
    }
}
