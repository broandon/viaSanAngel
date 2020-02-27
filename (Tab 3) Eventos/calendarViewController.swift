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
    var eventosParaCalendario : Array<String> = []
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
        
    }()
    
    @IBOutlet weak var calendar: FSCalendar!
    
    //MARK: viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        downloadAllDates()
        
        calendar.dataSource = self
        calendar.delegate = self
        
        var dateComponents = DateComponents()
        dateComponents.year = 2020
        dateComponents.month = 01
        dateComponents.day = 01
        let userCalendar = Calendar.current
        calendar.setCurrentPage(userCalendar.date(from: dateComponents)!, animated: false)                
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let date = Date()
        
        let calendar2 = Calendar.current
        
        var dateComponents = DateComponents()
        dateComponents.year = calendar2.component(.year, from: date)
        dateComponents.month = calendar2.component(.month, from: date)
        dateComponents.day = calendar2.component(.day, from: date)
        
        let userCalendar = Calendar.current
        
        calendar.setCurrentPage(userCalendar.date(from: dateComponents)!, animated: true)
                
    }
    
    
    //MARK: Func
    
    internal func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let dateString = self.dateFormatter2.string(from: date)
        
        if self.eventosParaCalendario.contains(dateString) {
            return 1
        }
        
        if self.eventosParaCalendario.contains(dateString) {
            return 3
        }
        
        return 0
    }


    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        var dateString = self.dateFormatter2.string(from: date)
        
        if self.eventosParaCalendario.contains(dateString) {
            
            print(self.dateFormatter2.string(from: date))
            print("this contains stuff")
            
                let lastDateString = "\(dateString)"
            print(lastDateString)
            
            if lastDateString == "2020-02-28" {
                
                
                   UserDefaults.standard.set("1", forKey: "eventID")
                
                   let storyBoard: UIStoryboard = UIStoryboard(name: "eventsDetails", bundle: nil)
                   let vc = storyBoard.instantiateViewController(withIdentifier: "eventsDetailsViewController") as! eventsDetailsViewController
                   present(vc, animated: true, completion: nil)
                
                
            }
            
            if lastDateString == "2020-03-10" {
                
                
                   UserDefaults.standard.set("2", forKey: "eventID")
                
                   let storyBoard: UIStoryboard = UIStoryboard(name: "eventsDetails", bundle: nil)
                   let vc = storyBoard.instantiateViewController(withIdentifier: "eventsDetailsViewController") as! eventsDetailsViewController
                   present(vc, animated: true, completion: nil)
                
            }
            
        } else {
            
            print("Nothing here")
            
        }
        
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let dateString = self.dateFormatter2.string(from: date)
        
        if self.eventosParaCalendario.contains(dateString) {
            
            cell.eventIndicator.numberOfEvents = 1
            
        }
        
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
                
                if let dictionary = json as? [String: Any]
                    
                {
                    
                    if let items = dictionary["data"] as? [Dictionary<String, Any>] {
                        
                        for d in items {
                            
                            self.eventos.append(d)
                            
                            print(self.eventos.count)
                        }
                        
                    }
                    
                    if let data = dictionary["data"] as? [[String: Any]] {
                        
                        
                        for datas in data {
                                                        
                            if let fechaReal = datas["fecha"] as? String {
                                
                                self.eventosParaCalendario.append(fechaReal)

                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                
            }
            
        }.resume()
        
        DispatchQueue.main.async { self.calendar.reloadData() }
        
    }
    
}
