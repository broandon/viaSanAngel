//
//  signUpViewController.swift
//  viaSanAngel
//
//  Created by Brandon Gonzalez on 10/6/19.
//  Copyright © 2019 Brandon Gonzalez. All rights reserved.
//

import UIKit
import Hero
import NVActivityIndicatorView

class signUpViewController: UIViewController, NVActivityIndicatorViewable {
    
    //MARK: Outlets
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var surname: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var password: UITextField!
    
    let http = HTTPViewController()
    
    //MARK: viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    //MARK: Buttons
    
    @IBAction func closeVC(_ sender: Any) {
        
        self.hero.isEnabled = true
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "signInViewController") as! signInViewController
        newViewController.hero.modalAnimationType = .pageOut(direction: .right)
        
        self.hero.replaceViewController(with: newViewController)
        
    }
    
    //MARK: Funcs
    
    @IBAction func createAccount(_ sender: Any) {
        
        checkTextFields()
        
        startAnimating(type: .ballClipRotatePulse)
        
        // POST REQUEST
        
        let url = URL(string: http.baseURL())!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
        request.httpMethod = "POST" // Metodo
        
        let postString = "funcion=newUser&first_name="+name.text!+"&last_name="+surname.text!+"&phone="+phone.text!+"&email="+mail.text!+"&password="+password.text!+"&type_device=1&facebook_login=" // Parametros
        
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
                                newViewController.hero.modalAnimationType = .zoomSlide(direction: .down)
                                
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
    
    func checkTextFields() {
        
        if name.text!.isEmpty {
            
            name.backgroundColor = UIColor(red: 0.82, green: 0.11, blue: 0.28, alpha: 1.00)
            
            name.textColor = .white
            
            let alert = UIAlertController(title: "Falta un dato", message: "Revisa los campos vacios.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Intentar de nuevo", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
            return
            
        }
        
        if surname.text!.isEmpty {
            
            surname.backgroundColor = UIColor(red: 0.82, green: 0.11, blue: 0.28, alpha: 1.00)
            
            surname.textColor = .white
            
            let alert = UIAlertController(title: "Falta un dato", message: "Revisa los campos vacios.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Intentar de nuevo", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
            return
            
        }
        
        if phone.text!.isEmpty {
            
            phone.backgroundColor = UIColor(red: 0.82, green: 0.11, blue: 0.28, alpha: 1.00)
            
            phone.textColor = .white
            
            let alert = UIAlertController(title: "Falta un dato", message: "Revisa los campos vacios.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Intentar de nuevo", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
            return
            
        }
        
        if mail.text!.isEmpty {
            
            mail.backgroundColor = UIColor(red: 0.82, green: 0.11, blue: 0.28, alpha: 1.00)
            
            mail.textColor = .white
            
            let alert = UIAlertController(title: "Falta un dato", message: "Revisa los campos vacios.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Intentar de nuevo", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
            return
            
        }
        
        if password.text!.isEmpty {
            
            password.backgroundColor = UIColor(red: 0.82, green: 0.11, blue: 0.28, alpha: 1.00)
            
            password.textColor = .white
            
            let alert = UIAlertController(title: "Falta un dato", message: "Revisa los campos vacios.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Intentar de nuevo", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
            return
            
        }
        
    }
    
}
