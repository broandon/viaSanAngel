//
//  eventsDetailsTableViewController.swift
//  viaSanAngel
//
//  Created by Brandon Gonzalez on 27/02/20.
//  Copyright © 2020 Brandon Gonzalez. All rights reserved.
//

import UIKit
import SDWebImage

class eventsDetailsTableViewController: UITableViewController {
    
    @IBOutlet weak var imagenEvento: UIImageView!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var inicioHora: UILabel!
    @IBOutlet weak var finHora: UILabel!
    @IBOutlet weak var etiquetaDescripción: UILabel!
    
    let http = HTTPViewController()
    let userInfo = UserDefaults.standard.string(forKey: "userID")
    let eventID = UserDefaults.standard.string(forKey: "eventID")


    override func viewDidLoad() {
        super.viewDidLoad()

        getTheDescription()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        
        
        return 3
    }
    
    
    func getTheDescription() {
        
        // POST REQUEST
        
        let url = URL(string: http.baseURL())!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
        request.httpMethod = "POST" // Metodo
        
        let postString = "funcion=getEventsDetail&id_user="+userInfo!+"&id_event="+eventID! // Parametros
        
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
                            
                            let imagenMain = info["imagen_evento"] as! String
                            let fecha = info["fecha"] as! String
                            let inicioHora = info["inicio_evento"] as! String
                            let finHora = info["fin_evento"] as! String
                            let descripcion = info["descripcion"]
                            
                            let imagenURL = URL(string: imagenMain)
                            
                            
                            DispatchQueue.main.async {
                                
                                self.etiquetaDescripción.text = descripcion as! String
                                
                                self.fechaLabel.text = fecha
                                
                                self.inicioHora.text = inicioHora
                                
                                self.finHora.text = finHora
                                
                                self.imagenEvento.sd_setImage(with: imagenURL, completed: nil)
                                
                            }
                            
                        }
                        
                        DispatchQueue.main.async {
                            
                            self.tableView.reloadData()
                            
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
        }
        
        task.resume()
        
    }


}
