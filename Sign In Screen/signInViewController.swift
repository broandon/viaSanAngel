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
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func forgottenAccountButton(_ sender: Any) {
        
        self.hero.isEnabled = true
             
             let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
             let newViewController = storyBoard.instantiateViewController(withIdentifier: "recoverAccount") as! signInViewController
        newViewController.hero.modalAnimationType = .zoom
        
             self.hero.replaceViewController(with: newViewController)
        
    }
    
    @IBAction func createAccount(_ sender: Any) {
        
        
             self.hero.isEnabled = true
                  
                  let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                  let newViewController = storyBoard.instantiateViewController(withIdentifier: "signUp") as! signUpViewController
             newViewController.hero.modalAnimationType = .zoom
             
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
        
        self.hero.isEnabled = true
             
             let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
             let newViewController = storyBoard.instantiateViewController(withIdentifier: "signInViewController") as! signInViewController
        newViewController.hero.modalAnimationType = .zoomOut
        
             self.hero.replaceViewController(with: newViewController)
        
        
    }
    
    
    
}

extension UITextField {

    @IBInspectable var doneAccessory: Bool {

        get {
            return self.doneAccessory
        }

        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard() {

        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {

        self.resignFirstResponder()

    }
}
