//
//  profileViewController.swift
//  viaSanAngel
//
//  Created by Brandon Gonzalez on 17/01/20.
//  Copyright © 2020 Brandon Gonzalez. All rights reserved.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView
import Alamofire
import Hero

class profileViewController: UIViewController, NVActivityIndicatorViewable {
    
    //MARK: Outlets
    
    @IBOutlet weak var profileImage: UIButton!
    
    var imagePicker: ImagePicker!
    var http = HTTPViewController()
    let userInfo = UserDefaults.standard.string(forKey: "userID")
    
    @IBOutlet weak var nombreTextfield: UITextField!
    @IBOutlet weak var apellidoTextfield: UITextField!
    @IBOutlet weak var numeroTextfield: UITextField!
    @IBOutlet weak var mailTextfield: UITextField!
    
    //MARK: viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startAnimating(type: .ballClipRotatePulse)
        setupProfileImage()
        getUserInfo()
        stopAnimating()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
    }
    
    //MARK: Funcs
    
    func setupProfileImage() {
        
        profileImage.layer.cornerRadius = 30
        profileImage.layer.borderColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00).cgColor
        profileImage.layer.borderWidth = 3
        profileImage.clipsToBounds = true
        
    }
    
    func getImageFromInernet(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        
        // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.profileImage.setImage(image, for: .normal)
            }
        }
    }
    
    func getUserInfo() {
        
        startAnimating(type: .ballClipRotatePulse)
        
        // POST REQUEST
        
        let url = URL(string: http.baseURL())!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
        request.httpMethod = "POST" // Metodo
        
        let postString = "funcion=getUserInfo&id_user="+userInfo! // Parametros
        
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
                    
                    if let data = dictionary["data"] {
                        
                        if let info = data["info"] as? Dictionary<String, Any> {
                            
                            print("INFO")
                            print(info)
                            
                            let nombre = info["nombre"]
                            let apellido = info["apellidos"]
                            let telefono = info ["telefono"]
                            let imagen = info ["imagen"] as! String
                            
                            let imageURL = URL(string: imagen)
                            
                            DispatchQueue.main.async {
                                
                                self.nombreTextfield.text! = nombre as! String
                                self.apellidoTextfield.text! = apellido as! String
                                self.numeroTextfield.text! = telefono as! String
                                
                                self.profileImage.sd_setImage(with: imageURL, for: .normal, completed: nil)
                                
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
    
    //MARK: Buttons
    
    @IBAction func saveAllInfo(_ sender: Any) {
        
        startAnimating(type: .ballClipRotatePulse)
        
        // -------
        
        let url = URL(string: self.http.baseURL())!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
        request.httpMethod = "POST" // Metodo
        
        let postString = "funcion=updateUser&id_user="+self.userInfo!+"&phone="+self.numeroTextfield.text!+"&first_name="+self.nombreTextfield.text!+"&last_name="+self.apellidoTextfield.text!  // Parametros
        
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
                    
                    if let state = dictionary["state"]{
                        
                        let stateString = "\(state)"
                        
                        if stateString == "200" {
                            
                            DispatchQueue.main.async {
                                
                                let alert = UIAlertController(title: "¡Exito!", message: "Tu información ha sido actualizada.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Muy bien", style: .cancel, handler: { action in
                                    
                                    self.hero.isEnabled = true
                                    
                                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "configuracionViewController") as! configuracionViewController
                                    newViewController.hero.modalAnimationType = .auto
                                    
                                    self.hero.replaceViewController(with: newViewController)
                                    
                                }))
                                
                                self.present(alert, animated: true)
                                
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
        
        // ---------
        
    }
    
    
    
    @IBAction func pickPhoto(_ sender: UIButton) {
        
        self.imagePicker.present(from: sender)
        
    }
    
    @IBAction func close(_ sender: Any) {
        
        self.hero.isEnabled = true
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "configuracionViewController") as! configuracionViewController
        
        newViewController.hero.modalAnimationType = .auto
        
        self.hero.replaceViewController(with: newViewController)
        
    }
    
}

//MARK: Extensions

extension profileViewController : ImagePickerDelegate  {
    
    func didSelect(image: UIImage?) {
        
        
        // -----------------------------------------------------------------
        
        startAnimating(type: .ballClipRotatePulse)
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        Alamofire.upload(
            multipartFormData: { MultipartFormData in
                MultipartFormData.append("uploadImage".data(using: String.Encoding.utf8)!, withName: "funcion")
                let imgString = image?.toBase64()
                MultipartFormData.append(imgString!.data(using: String.Encoding.utf8)!, withName: "image")
        }, to: "http://easycode.mx/viasanangel/webservice/controller_last.php", method: .post, headers: headers) { (result) in
            
            // print("just before the switch")
            
            switch result {
                
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    if let resultImage = response.result.value as? Dictionary<String, Any> {
                        
                        if let data = resultImage["data"] as? Dictionary<String, Any>{
                            
                            if let imageForProfile = data["image_name"] {
                                
                                let finalImage = imageForProfile as! String
                                
                                let finalImageURL = URL(string: finalImage)
                                
                                DispatchQueue.main.async {
                                    
                                    self.profileImage.sd_setImage(with: finalImageURL, for: .normal, completed: nil)
                                    
                                }
                                
                                // -----------------
                                
                                let url = URL(string: self.http.baseURL())!
                                
                                var request = URLRequest(url: url)
                                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
                                request.httpMethod = "POST" // Metodo
                                
                                let postString = "funcion=updateUser&id_user="+self.userInfo!+"&image="+finalImage+"&phone="+self.numeroTextfield.text!+"&first_name="+self.nombreTextfield.text!+"&last_name="+self.apellidoTextfield.text!  // Parametros
                                
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
                                            
                                            if let state = dictionary["state"]{
                                                
                                                let stateString = "\(state)"
                                                
                                                if stateString == "200" {
                                                    
                                                    DispatchQueue.main.async {
                                                        
                                                        print("Uploaded 2")
                                                        
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
                                
                                // ---------
                                
                            }
                        }
                        
                    }
                        
                    else {
                        
                        print("Ocurrio un error al procesar la imagen.")
                        return
                        
                    }
                    
                }
                
            case .failure(let encodingError):
                
                break
                
            }
            
        }
        
    }
    
}
