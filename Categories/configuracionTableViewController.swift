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
    
    //MARK: Outlets
    
    //MARK: viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    //MARK: Buttons
    
    @IBAction func closeSession(_ sender: Any) {
                
        let alert = UIAlertController(title: "Cerrar Sesión", message: "¿De verdad quieres cerrar la sesión? Deberás introducir tu mail y contraseña nuevamente.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cerrar sesión", style: .destructive, handler: { action in
                        
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            
            self.hero.isEnabled = true
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "signInViewController") as! signInViewController
            newViewController.hero.modalAnimationType = .pageIn(direction: .down)
            
            self.hero.replaceViewController(with: newViewController)
            
        }))

        self.present(alert, animated: true)
        
    }
    
    
    //MARK: Funcs
    
}
