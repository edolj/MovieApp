//
//  YoutubeUrlRetriever.swift
//  NewMovies
//
//  Created by Edo Ljubijankic on 16/09/2020.
//  Copyright © 2020 Edo Ljubijankic. All rights reserved.
//

import Foundation

class YoutubeUrlRetriever {
    
    static var keyID: String?
    
    static func getYoutubeURL(imdbID: String) {
        let urlApi = String(format: "http://api.themoviedb.org/3/movie/%@?api_key=%@", imdbID, ApiKey.tmdb)
        guard let url = URL(string: urlApi) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Error with URLSession.")
            } else {
                do {
                    if let jsonFile = try JSONSerialization.jsonObject(with: data ?? Data(),
                                                                       options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary {
                        let parseID = (jsonFile["id"] as? Int) ?? 0
                        let videoApiString = String(format: "http://api.themoviedb.org/3/movie/%@/videos?api_key=%@", String(parseID), ApiKey.tmdb)
                        if let videoUrl = URL(string: videoApiString) {
                            getKeyID(url: videoUrl)
                        }
                    }
                } catch {
                    print("Error in parsing data from JSON.")
                }
            }
        }
        task.resume()
    }
    
    static func getKeyID(url: URL) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Error with URLSession.")
            } else {
                do {
                    if let jsonFile = try JSONSerialization.jsonObject(with: data ?? Data(),
                                                                       options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary {
                        if let dataArray = jsonFile["results"] as? [NSDictionary],
                            dataArray.count != 0 {
                            keyID = dataArray[0]["key"] as? String
                        } else {
                            print("No keyID means no video trailer.")
                        }
                    }
                } catch {
                    print("Error in parsing data from JSON.")
                }
            }
        }
        task.resume()
    }
    
}
