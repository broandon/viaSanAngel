//
//  calendarViewController.swift
//  viaSanAngel
//
//  Created by Brandon Gonzalez on 10/02/20.
//  Copyright © 2020 Brandon Gonzalez. All rights reserved.
//

import UIKit
import FSCalendar

class calendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    //MARK: Outlets
    
    var eventos : [Dictionary<String, Any>] = []
    var reuseDocument = "DocumentoCellEventosCalendar"
    let userInfo = UserDefaults.standard.string(forKey: "userID")
    let http = HTTPViewController()

    @IBOutlet weak var calendar: FSCalendar!
    
    //MARK: viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        calendar.dataSource = self
        calendar.delegate = self
        
        downloadAllDates()

    }
    
    //MARK: Func
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy/MM/dd"
          dateFormatter.locale = Locale.init(identifier: "es_MX")
        
        return 1
        
    }
    
    func downloadAllDates() {
        
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
                
                if let dictionary = json as? Dictionary<String, Any>
                    
                {
                    if let items = dictionary["data"] as? Dictionary<String, Any> {
                        
                        print("ITEMS HERE")
                        print(items)
                        
                        if let fechas = items["fecha"] as? [Dictionary<String, Any>] {

                        print(fechas)


                        }
                        
//                        if let fechasReales = items["fecha"] as? [Dictionary<String, Any>] {
//
//                            print("FECHAS")
//                            print(fechasReales)
//
//                        }
//
//                        for d in items {
//
//                          //  self.eventos.append(d)
//
//                        }
                        
                    }
                    
                }
                
            }
            
        }.resume()
        
    }
    
}
