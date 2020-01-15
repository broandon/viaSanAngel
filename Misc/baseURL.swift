//
//  baseURL.swift
//  viaSanAngel
//
//  Created by Brandon Gonzalez on 1/11/20.
//  Copyright © 2020 Brandon Gonzalez. All rights reserved.
//

import UIKit

class HTTPViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    func baseURL() -> String {
        
        let URLString = "http://easycode.mx/viasanangel/webservice/controller_last.php"
        
        return URLString
        
    }
    
}
