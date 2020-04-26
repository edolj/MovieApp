//
//  VideoViewController.swift
//  NewMovies
//
//  Created by Edo Ljubijankic on 17/03/2018.
//  Copyright © 2018 Edo Ljubijankic. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

class VideoViewController: UIViewController {
    
    @IBOutlet weak var playerView: WKYTPlayerView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    var imdbID: String?
    var keyID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerView.isHidden = true
        playerView.backgroundColor = .clear
        loadingLabel.text = "loading".localized
        loadingLabel.textColor = .white
        view.backgroundColor = Color.background
        
        if let imdbID = imdbID {
            let urlApi = String(format: "http://api.themoviedb.org/3/movie/%@?api_key=%@", imdbID, ApiKey.tmdb)
            let url = URL(string: urlApi)
            loadTrailerVideo(url: url)
        } else {
            showAlert()
        }
    }
    
    func loadTrailerVideo(url: URL?) {
        guard let url = url else {
            showAlert()
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Error with URLSession.")
            } else {
                do {
                    if let jsonFile = try JSONSerialization.jsonObject(with: data ?? Data(),
                                                                       options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary {
                        let parseID = (jsonFile["id"] as? Int) ?? 0
                        let videoApiString = String(format: "http://api.themoviedb.org/3/movie/%@/videos?api_key=%@", String(parseID), ApiKey.tmdb)
                        let videoUrl = URL(string: videoApiString)
                        self.setupURLSession(url: videoUrl)
                    }
                } catch {
                    print("Error in parsing data from JSON.")
                }
            }
        }
        task.resume()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let key = self.keyID {
                self.playerView.load(withVideoId: key)
                self.autoplayVideo()
            } else {
                self.showAlert()
            }
        }
    }
    
    func autoplayVideo() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.loadingLabel.isHidden = true
            self.playerView.isHidden = false
            self.playerView.playVideo()
        }
    }
    
    func setupURLSession(url: URL?) {
        guard let url = url else {
            showAlert()
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Error with URLSession.")
            } else {
                do {
                    if let jsonFile = try JSONSerialization.jsonObject(with: data ?? Data(),
                                                                       options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary {
                        if let dataArray = jsonFile["results"] as? [NSDictionary],
                            dataArray.count != 0 {
                            self.keyID = dataArray[0]["key"] as? String
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

    func showAlert() {
        let alert = UIAlertController(title: "alert".localized, message: "noVideo".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "return".localized, style: UIAlertAction.Style.cancel, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    deinit {
        print("--class VideoViewController--")
    }
}
