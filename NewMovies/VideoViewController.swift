//
//  VideoViewController.swift
//  NewMovies
//
//  Created by Edo Ljubijankic on 17/03/2018.
//  Copyright © 2018 Edo Ljubijankic. All rights reserved.
//

import UIKit
import WebKit

class VideoViewController: UIViewController {
    
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    var imdbID: String?
    var keyID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        
        webview.addSubview(activityView)
        webview.navigationDelegate = self
        
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
        
        activityView.startAnimating()
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let key = self.keyID,
                let yturl = URL(string: "https://www.youtube.com/watch?v=\(key)") {
                    let request = URLRequest(url: yturl)
                    self.webview.load(request)
                }
            else {
                self.showAlert()
            }
        }
    }
    
    func setupURLSession(url: URL?) {
        guard let url = url else {
            showAlert()
            return
        }
        
        let task2 = URLSession.shared.dataTask(with: url) { (data, response, error) in
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
        task2.resume()
    }

    func showAlert() {
        let alert = UIAlertController(title: "Alert", message: "No trailer found.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.cancel, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    deinit {
        print("--class VideoViewController--")
    }
}

extension VideoViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityView.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityView.stopAnimating()
    }
}
