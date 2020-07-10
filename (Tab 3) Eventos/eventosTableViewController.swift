//
//  eventosTableViewController.swift
//  viaSanAngel
//
//  Created by Brandon Gonzalez on 10/02/20.
//  Copyright © 2020 Brandon Gonzalez. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SDWebImage
import TableViewReloadAnimation
import Hero

class eventosTableViewController: UITableViewController {
    
    //MARK: Outlets
    
    var eventos : [Dictionary<String, Any>] = []
    var reuseDocument = "DocumentoCellEventos"
    let userInfo = UserDefaults.standard.string(forKey: "userID")
    let http = HTTPViewController()
    
    //MARK: viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        downloadEventos()
        print(eventos)
        
    }
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 420)
        tableView.separatorStyle = .none
        
        let documentXib = UINib(nibName: "eventosTableViewCell", bundle: nil)
        tableView.register(documentXib, forCellReuseIdentifier: reuseDocument)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 232
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if eventos.count == 0 {
            self.tableView.setEmptyMessage("Estamos cargando los eventos.")
        } else {
            self.tableView.restore()
        }
        
        return eventos.count
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        let document = eventos[indexPath.row]
        
        print(document)
             
             let eventID = document["Id"] as! String
             
             UserDefaults.standard.set(eventID, forKey: "eventID")
          
             let storyBoard: UIStoryboard = UIStoryboard(name: "eventsDetails", bundle: nil)
             let vc = storyBoard.instantiateViewController(withIdentifier: "eventsDetailsViewController") as! eventsDetailsViewController
             present(vc, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let document = eventos[indexPath.row]
        
        let anotherDocument = eventos
        print(anotherDocument)
        
        let imagen = document["imagen_evento"] as! String
        let titulo = document["nombre"] as! String
        
        let furl = URL(string: imagen)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseDocument, for: indexPath)
        
        cell.selectionStyle = .none
        
        if let cell = cell as? eventosTableViewCell {
            
            DispatchQueue.main.async {
                
                cell.eventName.text! = titulo
                cell.imageEvent.sd_setImage(with: furl, completed: nil)
                
            }
            
            return cell
            
        }
        
        return UITableViewCell()
        
    }
    
    func downloadEventos() {
        
        let url = URL(string: http.baseURL())!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "funcion=getEvents&id_user="+userInfo!
        
        request.httpBody = postString.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil, response != nil else {
                return
            }
            
            do {
                
                
                let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                
                if let dictionary = json as? Dictionary<String, AnyObject>
                    
                {
                    
                    print(dictionary)
                    
                    if let items = dictionary["data"] as? [Dictionary<String, Any>] {
                        
                        for d in items {
                            
                            self.eventos.append(d)
                            
                        }
                        
                    }
                    
                }
                
                DispatchQueue.main.async {
                    if self.eventos.count > 0 {
                        self.tableView.reloadData(with: .simple(duration: 0.45, direction: .top(useCellsFrame: true), constantDelay: 0))
                        
                    }
                    
                }
                
            }
            
        }.resume()
        
        print("These are the events")
        print(eventos)
        print("********************")
        
    }
    
}
