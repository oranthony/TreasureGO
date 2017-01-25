//
//  WebViewController.swift
//  Test1
//
//  Created by anthony loroscio on 25/01/2017.
//  Copyright © 2017 anthony loroscio. All rights reserved.
//

import Foundation
import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        if let url = URL(string: "http://apple.com") {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }
}
