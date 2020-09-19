//
//  WebViewController.swift
//  NewMovies
//
//  Created by Edo Ljubijankic on 19/09/2020.
//  Copyright © 2020 Edo Ljubijankic. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var youtubeURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        view.backgroundColor = Color.background
        
        startVideo()
    }
    
    func startVideo() {
        guard let url = youtubeURL else { return }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
}
