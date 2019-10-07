//
//  configuracionTableViewController.swift
//  viaSanAngel
//
//  Created by Brandon Gonzalez on 10/6/19.
//  Copyright © 2019 Brandon Gonzalez. All rights reserved.
//

import UIKit
import Hero

class configuracionTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        

    }

    @IBAction func myProfile(_ sender: Any) {
        
        self.hero.isEnabled = true
             
             let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
             let newViewController = storyBoard.instantiateViewController(withIdentifier: "myProfileViewController") as! myProfileViewController
        newViewController.hero.modalAnimationType = .pull(direction: .up)
        
             self.hero.replaceViewController(with: newViewController)
        
    }
    
}
