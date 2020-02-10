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
            newViewController.hero.modalAnimationType = .push(direction: .down)

            self.hero.replaceViewController(with: newViewController)
            
        }))
        
        self.present(alert, animated: true)
        
    }
    
    @IBAction func terminosYCondiciones(_ sender: Any) {
        
        UIApplication.shared.open(URL(string: "https://1.bp.blogspot.com/-ceXwrhGFgyU/XPUiDKupbHI/AAAAAAAAYXw/625TmGowYkAkLAPYUyh7jPE7ie8XSY36wCLcBGAs/s320/2019-06-03_133234.png")!)
        
    }
    
    
    @IBAction func openFacebookProfile(_ sender: Any) {
        
        let fbURLWeb: NSURL = NSURL(string: "https://www.facebook.com/ccviasanangel/")!
        let fbURLID: NSURL = NSURL(string: "fb://profile/3076468245700823")!
        
        if(UIApplication.shared.canOpenURL(fbURLID as URL)){
            // FB installed
            UIApplication.shared.openURL(fbURLID as URL)
        } else {
            // FB is not installed, open in safari
            UIApplication.shared.openURL(fbURLWeb as URL)
        }
        
    }
    
    @IBAction func openInstagramProfile(_ sender: Any) {
        
        let instaURLWeb: NSURL = NSURL(string: "https://www.instagram.com/via.sanangel/")!
        let instaURLID: NSURL = NSURL(string: "instagram://user?username=via.sanangel")!
        
        if(UIApplication.shared.canOpenURL(instaURLID as URL)){
            // FB installed
            UIApplication.shared.openURL(instaURLID as URL)
        } else {
            // FB is not installed, open in safari
            UIApplication.shared.openURL(instaURLWeb as URL)
        }
        
        
    }
    
    
    //MARK: Funcs
    
    @IBAction func openProfile(_ sender: Any) {
        
        self.hero.isEnabled = true

              let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
              let newViewController = storyBoard.instantiateViewController(withIdentifier: "myProfileViewController") as! profileViewController
        newViewController.hero.modalAnimationType = .auto

              self.hero.replaceViewController(with: newViewController)
        
    }
    
    
}
