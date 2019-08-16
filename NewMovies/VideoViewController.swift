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
        
        navigationItem.title = "Trailer"
        
        webview.addSubview(activityView)
        webview.navigationDelegate = self
        
        activityView.hidesWhenStopped = true
        activityView.startAnimating()
        
        if let imdbID = imdbID {
            let urlApi = "http://api.themoviedb.org/3/movie/\(imdbID)?api_key=1fe1b7a660e0e0e7cde9c78d327c03e8"
            let url = URL(string: urlApi)
            if let url = url {
                loadTrailerVideo(url: url)
            }
        }
    }
    
    func loadTrailerVideo(url: URL) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Error with URLSession.")
            } else {
                if let content = data {
                    do {
                        if let jsonFile = try JSONSerialization.jsonObject(with: content,
                        options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary,
                            let unwrapID = jsonFile["id"] {
                                let parseID = String(describing: unwrapID)
                                let secondUrl = "http://api.themoviedb.org/3/movie/\(parseID)/videos?api_key=1fe1b7a660e0e0e7cde9c78d327c03e8"
                            if let url2 = URL(string: secondUrl) {
                                let task2 = URLSession.shared.dataTask(with: url2) { (data2, response, error2) in
                                    if error2 != nil {
                                        print("Error with URLSession.")
                                    } else {
                                        if let content2 = data2 {
                                            do {
                                                if let jsonFile2 = try JSONSerialization.jsonObject(with: content2,
                                                options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary,
                                                let collect = jsonFile2.value(forKey: "results"),
                                                    let stringArray = collect as? [NSDictionary],
                                                    stringArray.count != 0,
                                                    let keyID = stringArray[0]["key"] as? String {
                                                        self.keyID = keyID
                                                    } else {
                                                        print("No keyID means no video trailer.")
                                                    }
                                                
                                            } catch {
                                                print("Error in parsing data from JSON.")
                                            }
                                        }
                                    }
                                }
                                task2.resume()
                            }
                        }
                        
                    } catch {
                        print("Error in parsing data from JSON.")
                    }
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
                let alert = UIAlertController(title: "Alert", message: "No trailer found.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.cancel, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
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
