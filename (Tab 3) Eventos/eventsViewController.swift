//
//  eventsViewController.swift
//  viaSanAngel
//
//  Created by Brandon Gonzalez on 10/02/20.
//  Copyright © 2020 Brandon Gonzalez. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class eventsViewController: UIViewController, NVActivityIndicatorViewable {
    
    //MARK: Outlets
    
    @IBOutlet weak var calendarSwitch: UISegmentedControl!
    @IBOutlet weak var containerViewEventos: UIView!
    @IBOutlet weak var containerViewCalendario: UIView!
    
    //MARK: viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    //MARK: Funcs
    
    //MARK: Buttons
    
    @IBAction func controllerSwitch(_ sender: Any) {
        
        switch calendarSwitch.selectedSegmentIndex {
        case 0:
            containerViewEventos.isHidden = true
            containerViewCalendario.isHidden = false
        case 1:
            containerViewCalendario.isHidden = true
            containerViewEventos.isHidden = false
        default:
            break;
        }
        
    }
    
}
