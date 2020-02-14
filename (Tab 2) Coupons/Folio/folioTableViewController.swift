//
//  folioTableViewController.swift
//  viaSanAngel
//
//  Created by Brandon Gonzalez on 11/02/20.
//  Copyright © 2020 Brandon Gonzalez. All rights reserved.
//

import UIKit

class folioTableViewController: UITableViewController {
    
    
    @IBOutlet weak var imagenCupon: UIImageView!
    @IBOutlet weak var textoCupon: UILabel!
    @IBOutlet weak var folio: UILabel!
    @IBOutlet weak var descripcionFolio: UITextView!
    
    let http = HTTPViewController()
    let userInfo = UserDefaults.standard.string(forKey: "userID")
    let couponID = UserDefaults.standard.string(forKey: "couponID")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        getFolio()
        folio.alpha = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1, animations: {
            
            self.folio.alpha = 100
            
        })
    }
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
        
    }
    
    func getFolio() {
        
        // POST REQUEST
        
        let url = URL(string: http.baseURL())!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
        request.httpMethod = "POST" // Metodo
        
        let postString = "funcion=getFolioCoupon&id_user="+userInfo!+"&id_coupon="+couponID! // Parametros
        
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
                            
                            let imageMain = info["logo_marca"] as! String
                            let promocion = info["promocion"] as! String
                            let folio = info["folio"] as! String
                            
                            
                            
                            let imageMainURL = URL(string: imageMain)
                            
                            DispatchQueue.main.async {
                            
                                self.imagenCupon.sd_setImage(with: imageMainURL, completed: nil)
                                self.textoCupon.text = promocion
                                self.folio.text = folio
        
                            }
                            
                        }
                        
                    }
                    
                    if let state = dictionary["state"]{
                        
                        let stateString = "\(state)"
                        
                        if stateString == "200" {
                            
                            DispatchQueue.main.async {
                                
                                                                
                            }
                            
                        } else if stateString == "101" {
                            
                            DispatchQueue.main.async {
                                
                                
                                let alert = UIAlertController(title: "Error", message: "El usuario no ha sido encontrado. Verifica que tus datos estén bien escritos o la contraseña sea la correcta.", preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "Volver a intentar", style: .default, handler: nil))
                                
                                self.present(alert, animated: true)
                                
                            }
                            
                        } else {
                            
                            DispatchQueue.main.async {
                                
 
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
    
    @IBAction func Entendido(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
    
    }
    
    
}
