//
//  signInViewController.swift
//  viaSanAngel
//
//  Created by Brandon Gonzalez on 10/4/19.
//  Copyright © 2019 Brandon Gonzalez. All rights reserved.
//

import UIKit
import Hero
import NVActivityIndicatorView
import SDWebImage

class signInViewController: UIViewController, NVActivityIndicatorViewable {
    
    //MARK: Outlets
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var recoverTextField: UITextField!
    @IBOutlet weak var viaLogo: UIImageView!
    
    
    let http = HTTPViewController()
    
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
        
        mailTextField.resignFirstResponder()
        passTextField.resignFirstResponder()
        
        if mailTextField.text!.isEmpty {
            
            // Alert with no action
            
            let alert = UIAlertController(title: "Error", message: "Por favor introduce tu correo.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Volver", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
            return
            
        }
        
        if passTextField.text!.isEmpty {
            
            // Alert with no action
            
            let alert = UIAlertController(title: "Error", message: "Por favor introduce tu contraseña.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Volver", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
            return
            
        }
        
        startAnimating(type: .ballClipRotatePulse)
        
        // POST REQUEST
        
        let url = URL(string: http.baseURL())!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
        request.httpMethod = "POST" // Metodo
        
        let postString = "funcion=login&email="+mailTextField.text!+"&password="+passTextField.text! // Parametros
        
        request.httpBody = postString.data(using: .utf8) // SE codifica a UTF-8
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Validacion para errores de Red
            
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            do {
                
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                print(" \n\n Respuesta: ")
                print(" ============ ")
                print(json as Any)
                print(" ============ ")
                
                if let parseJSON = json {
                    
                    if let state = parseJSON["state"]{
                        
                        let stateString = "\(state)"
                        
                        if stateString == "200" {
                            
                            DispatchQueue.main.async {
                                
                                self.stopAnimating()
                                
                                self.hero.isEnabled = true
                                
                                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainTabBarViewController") as! UITabBarController
                                newViewController.hero.modalAnimationType = .uncover(direction: .down)
                                
                                self.hero.replaceViewController(with: newViewController)
                                
                                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                
                            }
                            
                        } else if stateString == "101" {
                            
                            DispatchQueue.main.async {
                                
                                self.stopAnimating()
                                
                                let alert = UIAlertController(title: "Error", message: "El usuario no ha sido encontrado. Verifica que tus datos estén bien escritos o la contraseña sea la correcta.", preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "Volver a intentar", style: .default, handler: nil))
                                
                                self.present(alert, animated: true)
                                
                            }
                            
                        } else {
                            
                            DispatchQueue.main.async {
                                
                                self.stopAnimating()
                                
                                let alert = UIAlertController(title: "Error", message: "Hay un problema con el servidor, inténtalo de nuevo más tarde.", preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "Entendido", style: .default, handler: nil))
                                
                                self.present(alert, animated: true)
                                
                            }
                            
                        }
                        
                    }
                    
                    if let motherAccessToken = parseJSON["data"] {
                        if let motherAccessToken1 = motherAccessToken as? [String: String]{
                            if let accessTokenPre = motherAccessToken1["id_user"]{
                                
                                UserDefaults.standard.set(accessTokenPre, forKey: "userID")
                                
                            }
                        }
                    }
                }
            }
        }
        
        task.resume()
        
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
    
    @IBAction func recoverPassword(_ sender: Any) {
        
        recoverTextField.resignFirstResponder()
        
        if recoverTextField.text!.isEmpty {
            
            let alert = UIAlertController(title: "Error", message: "Por favor introduce tu correo electrónico.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Entendido", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            
            return
            
        }
        
        startAnimating(type: .ballClipRotatePulse)
        
        // POST REQUEST
        
        let url = URL(string: http.baseURL())!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
        request.httpMethod = "POST" // Metodo
        
        let postString = "funcion=recoverAccount&email="+recoverTextField.text! // Parametros
        
        request.httpBody = postString.data(using: .utf8) // SE codifica a UTF-8
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Validacion para errores de Red
            
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            do {
                
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                print(" \n\n Respuesta: ")
                print(" ============ ")
                print(json as Any)
                print(" ============ ")
                
                if let parseJSON = json {
                    
                    if let state = parseJSON["state"]{
                        
                        let stateString = "\(state)"
                        
                        if stateString == "200" {
                            
                            self.stopAnimating()
                            
                            DispatchQueue.main.async {
                                
                                let alert = UIAlertController(title: "¡Éxito!", message: "Se ha enviado un correo con instrucciones para recuperar tu cuenta.", preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "Entendido", style: .cancel, handler: { action in
                                    
                                    self.dismiss(animated: true, completion: nil)
                                    
                                }))
                                
                                self.present(alert, animated: true)
                                
                            }
                            
                        } else {
                            
                            self.stopAnimating()
                            
                            DispatchQueue.main.async {
                                
                                let alert = UIAlertController(title: "Error", message: "No hemos encontrado este correo. Revisa tus datos e inténtalo de nuevo.", preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "Entendido", style: .cancel, handler: nil))
                                
                                self.present(alert, animated: true)
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        task.resume()
        
    }
    
}
