//
//  StoresViewController.swift
//  viaSanAngel
//
//  Created by Brandon Gonzalez on 10/6/19.
//  Copyright © 2019 Brandon Gonzalez. All rights reserved.
//

import UIKit
import Hero
import NVActivityIndicatorView
import SDWebImage
import TableViewReloadAnimation

class StoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, UISearchBarDelegate {
    
    //MARK: Outlets
    
    var tiendas : [Dictionary<String, Any>] = []
    let reuseDocument = "DocumentoCellStores"
    let userInfo = UserDefaults.standard.string(forKey: "userID")
    let http = HTTPViewController()
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.isHidden = true
        setupTableView()
        downloadStores()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
    }
    
    //MARK: Funcs
    
    func setupTableView() {
        
        tableView.delegate = self
          tableView.dataSource = self
          searchBar.delegate = self
          tableView.separatorStyle = .none
          tableView.allowsSelection = true
          tableView.separatorInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 420)
                    
          let documentXib = UINib(nibName: "tiendasTableViewCell", bundle: nil)
          tableView.register(documentXib, forCellReuseIdentifier: reuseDocument)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let document = tiendas[indexPath.row]
        
        let couponID = document["Id"] as! String
        
        UserDefaults.standard.set(couponID, forKey: "StoreID")
        
        self.hero.isEnabled = true
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "storeDetail", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "storeDetailsViewController") as! storeDetailsViewController
        newViewController.hero.modalAnimationType = .zoom
        
        present(newViewController, animated: true, completion: nil)
        
//
//        self.hero.replaceViewController(with: newViewController)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 123
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let document = tiendas[indexPath.row]
        
        let logo = document["logo_marca"] as! String
        let imagenMarca = document["imagen_marca"] as! String
        
        let furl = URL(string: logo)
        let furl2 = URL(string: imagenMarca)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseDocument, for: indexPath)
        
        cell.selectionStyle = .none
        
        if let cell = cell as? tiendasTableViewCell {
            
            DispatchQueue.main.async {
                
                cell.imagenComida.sd_setImage(with: furl2, completed: nil)
                cell.logoTienda.sd_setImage(with: furl, completed: nil)
                
            }
            
            return cell
            
        }
        
        return UITableViewCell()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tiendas.count == 0 {
            self.tableView.setEmptyMessage("Estamos cargando tus tiendas.")
        } else {
            self.tableView.restore()
        }
        
        return tiendas.count
        
    }
    
    func downloadStores() {
        
        let url = URL(string: http.baseURL())!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "funcion=getStores&id_user="+userInfo!
        
        request.httpBody = postString.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil, response != nil else {
                return
            }
            
            do {
                
                
                let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                
                if let dictionary = json as? Dictionary<String, AnyObject>
                    
                {
                    
                    print("tiendas")
                    print(dictionary)
                    print("*********")
                    
                    if let items = dictionary["data"] as? [Dictionary<String, Any>] {
                        
                        for d in items {
                            
                            self.tiendas.append(d)
                            
                        }
                        
                    }
                    
                }
                
                DispatchQueue.main.async {
                    if self.tiendas.count > 0 {
                        self.tableView.reloadData(with: .simple(duration: 0.45, direction: .top(useCellsFrame: true), constantDelay: 0))
                        
                    }
                    
                }
                
            }
            
        }.resume()
        
    }
    
}
