//
//  signInViewController.swift
//  viaSanAngel
//
//  Created by Brandon Gonzalez on 10/4/19.
//  Copyright © 2019 Brandon Gonzalez. All rights reserved.
//

import UIKit
import Hero

class signInViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    //MARK: viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LogginCheckup()
        
    }
    
    //MARK: Buttons
    
    @IBAction func forgottenAccountButton(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "recoverAccount") as! signInViewController
        present(newViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func createAccount(_ sender: Any) {
        
        
        self.hero.isEnabled = true
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "signUp") as! signUpViewController
        newViewController.hero.modalAnimationType = .pageIn(direction: .left)
        
        self.hero.replaceViewController(with: newViewController)
        
    }
    
    @IBAction func signInButton(_ sender: Any) {
        
        self.hero.isEnabled = true
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainTabBarViewController") as! UITabBarController
        newViewController.hero.modalAnimationType = .zoomSlide(direction: .down)
        
        self.hero.replaceViewController(with: newViewController)
        
        
    }
    
    
    
    @IBAction func closeController(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    //MARK: Funcs
    
    func LogginCheckup() {
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == true {
            
            print("is true")
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homePage = storyBoard.instantiateViewController(withIdentifier: "mainTabBarViewController") as! UITabBarController
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = homePage
            
        }
        
    }
    
}
