//
//  myProfileViewController.swift
//  viaSanAngel
//
//  Created by Brandon Gonzalez on 10/6/19.
//  Copyright © 2019 Brandon Gonzalez. All rights reserved.
//

import UIKit
import Hero

class myProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        
        self.hero.isEnabled = true
             
             let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
             let newViewController = storyBoard.instantiateViewController(withIdentifier: "configuracionViewController") as! configuracionViewController
        newViewController.hero.modalAnimationType = .pull(direction: .down)
        
             self.hero.replaceViewController(with: newViewController)
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}
