//
//  signUpViewController.swift
//  viaSanAngel
//
//  Created by Brandon Gonzalez on 10/6/19.
//  Copyright © 2019 Brandon Gonzalez. All rights reserved.
//

import UIKit
import Hero

class signUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        
    }
    
    @IBAction func closeVC(_ sender: Any) {
            
                     self.hero.isEnabled = true
                  
                  let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                  let newViewController = storyBoard.instantiateViewController(withIdentifier: "signInViewController") as! signInViewController
             newViewController.hero.modalAnimationType = .zoomOut
             
                  self.hero.replaceViewController(with: newViewController)
        
        
    }
    

}
