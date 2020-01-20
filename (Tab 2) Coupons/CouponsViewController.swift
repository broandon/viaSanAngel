//
//  CouponsViewController.swift
//  viaSanAngel
//
//  Created by Brandon Gonzalez on 20/01/20.
//  Copyright © 2020 Brandon Gonzalez. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SDWebImage
import TableViewReloadAnimation
import Hero

class CouponsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, UISearchBarDelegate {
    
    //MARK: Outlets
    
    var cupones : [Dictionary<String, Any>] = []
    
    let reuseDocument = "DocumentoCellCoupons"
    
    let userInfo = UserDefaults.standard.string(forKey: "userID")
    
    let http = HTTPViewController()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 420)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        let documentXib = UINib(nibName: "cuponesTableViewCell", bundle: nil)
               tableView.register(documentXib, forCellReuseIdentifier: reuseDocument)
        
        downloadCoupons()
        
    }
    
    //MARK: Funcs
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if cupones.count == 0 {
            self.tableView.setEmptyMessage("Estamos cargando tus cupones.")
        } else {
            self.tableView.restore()
        }
        
        return cupones.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let document = cupones[indexPath.row]
        
        let imagen = document["imagen_cupon"] as! String
        let titulo = document["nombre"] as! String
        
        let furl = URL(string: imagen)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseDocument, for: indexPath)
        
        if let cell = cell as? cuponesTableViewCell {
            
            DispatchQueue.main.async {
                
                cell.imagenCupon.sd_setImage(with: furl, completed: nil)
                cell.tituloCupon.text = titulo
                
            }
            
            return cell
            
        }
        
        return UITableViewCell()
        
        
    }
    
    func downloadCoupons() {
        
        let url = URL(string: http.baseURL())!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "funcion=getCoupons&id_user="+userInfo!
        
        request.httpBody = postString.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil, response != nil else {
                return
            }
            
            do {
                
                
                let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                
                if let dictionary = json as? Dictionary<String, AnyObject>
                    
                {
                    
                    print("cupones")
                    print(dictionary)
                    print("*********")
                    
                    if let items = dictionary["data"] as? [Dictionary<String, Any>] {
                        
                        for d in items {
                            
                            self.cupones.append(d)
                            
                        }
                        
                    }
                    
                }
                
                DispatchQueue.main.async {
                    if self.cupones.count > 0 {
                        self.tableView.reloadData(with: .simple(duration: 0.45, direction: .top(useCellsFrame: true), constantDelay: 0))
                        
                    }
                    
                }
                
            }
            
        }.resume()
        
    }
    
}
