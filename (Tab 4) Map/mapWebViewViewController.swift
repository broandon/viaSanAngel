//
//  mapWebViewViewController.swift
//  viaSanAngel
//
//  Created by Brandon Gonzalez on 22/01/20.
//  Copyright © 2020 Brandon Gonzalez. All rights reserved.
//

import UIKit
import WebKit
import NVActivityIndicatorView

class mapWebViewViewController: UIViewController, WKNavigationDelegate, NVActivityIndicatorViewable, UIScrollViewDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Loaded map view")
        
        startAnimating(type: .ballClipRotatePulse)
        
        webView.scrollView.delegate = self
        webView.navigationDelegate = self
        
        let url = URL(string: "http://easycode.mx/viasanangel/mapaviaangel/mapaviasanangel.php")!
        
        webView.load(URLRequest(url: url))
        
        print("Loading map")
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        stopAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            webView.scrollView.setZoomScale(-3000, animated: true)
            
        }
        
        print("Finished loading")
        
    }
    
}
