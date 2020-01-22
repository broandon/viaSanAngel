//
//  couponDetailTableViewController.swift
//  viaSanAngel
//
//  Created by Brandon Gonzalez on 22/01/20.
//  Copyright © 2020 Brandon Gonzalez. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class couponDetailTableViewController: UITableViewController, NVActivityIndicatorViewable {
    
    //MARK: Outlets
    
    let http = HTTPViewController()
    let userInfo = UserDefaults.standard.string(forKey: "userID")
    let couponID = UserDefaults.standard.string(forKey: "couponID")
    
    @IBOutlet weak var imagenCupon: UIImageView!
    @IBOutlet weak var logoMarca: UIImageView!
    @IBOutlet weak var fechaCupon: UILabel!
    @IBOutlet weak var descuentoCupon: UILabel!
    @IBOutlet weak var categoriaLabel: UILabel!
    @IBOutlet weak var promocionText: UITextView!
    @IBOutlet weak var terminosText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        getCouponDetails()

    }
    
    func setupTableView() {
       
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        logoMarca.layer.borderWidth = 2
        logoMarca.layer.borderColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00).cgColor
        
        
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5

    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return 200
            
        }
        
        return UITableView.automaticDimension
    }
    
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
                            
                            let imageMain = info["imagen_cupon"] as! String
                            let logo = info["imagen_marca"] as! String
                            let vigencia = info["vigencia"] as! String
                            let descuento = info["descuento"] as! String
                            let categoria = info["nombre"] as! String
                            let promocion = info["promocion"] as! String
                            let condiciones = info["condiciones"] as! String
                            
                            let imageMainURL = URL(string: imageMain)
                            let logoURL = URL(string: logo)
                            
                            DispatchQueue.main.async {
                            
                                self.imagenCupon.sd_setImage(with: imageMainURL, completed: nil)
                                self.logoMarca.sd_setImage(with: logoURL, completed: nil)
                                self.fechaCupon.text = vigencia
                                self.descuentoCupon.text = descuento
                                self.categoriaLabel.text = categoria
                                self.promocionText.text = promocion
                                self.terminosText.text = condiciones
                                
                                self.stopAnimating()
        
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

}
