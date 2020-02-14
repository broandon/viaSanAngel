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

    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.dataSource = self
        calendar.delegate = self

    }
    
    
}
