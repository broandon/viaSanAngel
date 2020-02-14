//
//  couponDetailViewController.swift
//  viaSanAngel
//
//  Created by Brandon Gonzalez on 22/01/20.
//  Copyright © 2020 Brandon Gonzalez. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class couponDetailViewController: UIViewController, NVActivityIndicatorViewable {
    
    //MARK: Outlets
    
    let http = HTTPViewController()
    let userInfo = UserDefaults.standard.string(forKey: "userID")
    let couponID = UserDefaults.standard.string(forKey: "couponID")
    
    @IBOutlet weak var topLabel: UILabel!
    
    //MARK: viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCouponDetails()
        
    }
    
    //MARK: Funcs
    
    func getCouponDetails() {
        
        startAnimating(type: .ballClipRotatePulse)
        
        // POST REQUEST
        
        let url = URL(string: http.baseURL())!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
        request.httpMethod = "POST" // Metodo
        
        let postString = "funcion=getCouponDetail&id_user="+userInfo!+"&id_coupon="+couponID! // Parametros
        
        print(postString)
        
        request.httpBody = postString.data(using: .utf8) // SE codifica a UTF-8
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Validacion para errores de Red
            
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            do {
                
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                
                if let dictionary = json as? Dictionary<String, AnyObject>
                    
                {
                    
                    print(dictionary)
                    
                    if let data = dictionary["data"] {
                        
                        if let info = data["info"] as? Dictionary<String, Any> {
                            
                            let nombreMarca = info["nombre_marca"] as! String
                            
                            print(nombreMarca)
                            
                            DispatchQueue.main.async {
                                
                                self.topLabel.text = nombreMarca
                                
                            }
                            
                        }
                        
                    }
                    
                    if let state = dictionary["state"]{
                        
                        let stateString = "\(state)"
                        
                        if stateString == "200" {
                            
                            DispatchQueue.main.async {
                                
                                self.stopAnimating()
                                
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
                }
            }
        }
        
        task.resume()
        
    }
    @IBAction func goBack(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
