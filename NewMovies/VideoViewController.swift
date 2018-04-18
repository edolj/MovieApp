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
    
    var imdbID: String?
    var parseID: String?
    var keyID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadTrailerVideo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadTrailerVideo() {
        let urlApi = "http://api.themoviedb.org/3/movie/\(imdbID!)?api_key=1fe1b7a660e0e0e7cde9c78d327c03e8"
        
        //print(urlApi)
        let url = URL(string: urlApi)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil
            {
                print("error")
            }
            else
            {
                if let content = data
                {
                    do
                    {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                        
                        //print(myJson)
                        self.parseID = String(describing: myJson["id"]!)
                        //print(self.parseID!)
                        
                        let secondUrl = "http://api.themoviedb.org/3/movie/\(self.parseID!)/videos?api_key=1fe1b7a660e0e0e7cde9c78d327c03e8"
                        let url2 = URL(string: secondUrl)
                        let task2 = URLSession.shared.dataTask(with: url2!) { (data2, response, error2) in
                            if error2 != nil
                            {
                                print("error")
                            }
                            else
                            {
                                if let content2 = data2
                                {
                                    do
                                    {
                                        let myJson2 = try JSONSerialization.jsonObject(with: content2, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                                        
                                        //print(myJson2.value(forKey: "results")!)
                                        let collect = myJson2.value(forKey: "results")!
                                        if let stringArray = collect as? [NSDictionary] {
                                            //print(stringArray[0]["key"]!)
                                            self.keyID = stringArray[0]["key"]! as? String
                                        }
                                        else {
                                            print("not string")
                                        }
                                        
                                        //self.keyID = String(describing: myJson2)
                                        //print(self.keyID!)
                                    }
                                    catch
                                    {
                                        print("error in JSONSerialization")
                                    }
                                }
                            }
                        }
                        task2.resume()
                    
                    }
                    catch
                    {
                        print("error in JSONSerialization")
                    }
                }
            }
        }
        task.resume()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if(self.keyID != nil) {
                let yturl = URL(string: "https://www.youtube.com/watch?v=\(self.keyID!)")
                let request = URLRequest(url: yturl!)
                self.webview.load(request)
            } else {
                print("No content found.");
            }
        }
    
    }

}
