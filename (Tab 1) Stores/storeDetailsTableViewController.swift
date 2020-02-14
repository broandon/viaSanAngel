//
//  storeDetailsTableViewController.swift
//  viaSanAngel
//
//  Created by Brandon Gonzalez on 1/22/20.
//  Copyright © 2020 Brandon Gonzalez. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SDWebImage

class storeDetailsTableViewController: UITableViewController, NVActivityIndicatorViewable {
    
    //MARK: Outlets
    
    let http = HTTPViewController()
    let userInfo = UserDefaults.standard.string(forKey: "userID")
    let storeID = UserDefaults.standard.string(forKey: "StoreID")
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var openFrom: UILabel!
    @IBOutlet weak var openTo: UILabel!
    @IBOutlet weak var minimunPrice: UILabel!
    @IBOutlet weak var descriptionStore: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    
    //MARK: viewDid

    override func viewDidLoad() {
        super.viewDidLoad()

        getCouponDetails()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
         configureView()
    }

    // MARK: Funcs

    func configureView() {
        
        profileImage.layer.cornerRadius = 15
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
        
    }
    
    func getCouponDetails() {
        
        startAnimating(type: .ballClipRotatePulse)

        // POST REQUEST
        
        let url = URL(string: http.baseURL())!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
        request.httpMethod = "POST" // Metodo
        
        let postString = "funcion=getStoreDetail&id_user="+userInfo!+"&id_store="+storeID! // Parametros
        
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
                            
                            let categoria = info["categoria"] as! String
                            let openFrom = info["horario_inicio"] as! String
                            let openTo = info["horario_fin"] as! String
                            let minimum = info["precio"] as! String
                            let description = info["descripcion"] as! String
                            let backgroundImage = info["imagen_marca"] as! String
                            let logoMarca = info["logo_marca"] as! String
                            
                            let backgroundImageURL = URL(string: backgroundImage)
                            let logoMarcaURL = URL(string: logoMarca)
                            
                            DispatchQueue.main.async {
                                
                                self.stopAnimating()
                                
                                self.categoryLabel.text! = categoria
                                self.openFrom.text! = openFrom
                                self.openTo.text! = openTo
                                self.minimunPrice.text! = minimum
                                self.descriptionLabel.text = description
                                self.backgroundImage.sd_setImage(with: backgroundImageURL, completed: nil)
                                self.profileImage.sd_setImage(with: logoMarcaURL, completed: nil)
                                
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
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
                
            }
            
        }
        
        task.resume()
        
    }

}
