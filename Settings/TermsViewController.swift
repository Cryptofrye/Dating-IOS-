//
//  TermsViewController.swift
//  SocialApp
//
//  Created by Mac Book on 23.01.20.
//  Copyright © 2020 raccoonsquare@gmail.com. All rights reserved.
//

import UIKit
import WebKit

class TermsViewController: UIViewController, WKNavigationDelegate {
    
    
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        
        webView.navigationDelegate = self;
        webView.isUserInteractionEnabled = true;
        
        webView.isHidden = true
        
        let myURL = URL(string: Constants.METHOD_APP_TERMS)
        let myRequest = URLRequest(url: myURL!)
        
        webView.load(myRequest)
    }
    
    func webView(_ webView: WKWebView,didFinish navigation: WKNavigation!) {
    
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        
        webView.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }

}
