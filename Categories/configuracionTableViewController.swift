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
    
    @IBOutlet weak var cerrarSesionText: UILabel!
    let userInfo = UserDefaults.standard.string(forKey: "userID")
    
    //MARK: viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Showing settings view")
        
        
    }
    
    //MARK: Buttons
    
    @IBAction func closeSession(_ sender: Any) {
        
        print("Closing session")
        
        let alert = UIAlertController(title: "Cerrar Sesión", message: "¿De verdad quieres cerrar la sesión? Deberás introducir tu mail y contraseña nuevamente.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Cerrar sesión", style: .destructive, handler: { action in
            
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            UserDefaults.standard.removeObject(forKey: "userID")
            UserDefaults.standard.removeObject(forKey: "tokenFCM")
            
            self.resetRoot()
            
        }))
        
        self.present(alert, animated: true)
        
    }
    
    @IBAction func terminosYCondiciones(_ sender: Any) {
        
        UIApplication.shared.open(URL(string: "https://1.bp.blogspot.com/-ceXwrhGFgyU/XPUiDKupbHI/AAAAAAAAYXw/625TmGowYkAkLAPYUyh7jPE7ie8XSY36wCLcBGAs/s320/2019-06-03_133234.png")!)
        
    }
    
    @IBAction func openFacebookProfile(_ sender: Any) {
        
        let fbURLWeb: NSURL = NSURL(string: "https://www.facebook.com/ccviasanangel/")!
        let fbURLID: NSURL = NSURL(string: "fb://profile/ccviasanangel")!
        
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
    
    func resetRoot() {
           guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signInViewController") as? signInViewController else {
               return
           }

           UIApplication.shared.windows.first?.rootViewController = rootVC
           UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    @IBAction func openProfile(_ sender: Any) {
        
        if userInfo == "0" {
            
            // Alert with action
            
            let alert = UIAlertController(title: "¡Error!", message: "Para ver tu perfil debes iniciar sesión o crear una cuenta", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Entendido", style: .cancel, handler: { action in
                
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                
                self.resetRoot()
                
            }))
            
            self.present(alert, animated: true)
            
            return
            
        }
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "myProfileViewController") as! profileViewController
        
        present(newVC, animated: true, completion: nil)
        
    }
    
}
