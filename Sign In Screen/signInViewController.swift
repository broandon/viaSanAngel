//
//  signInViewController.swift
//  viaSanAngel
//
//  Created by Brandon Gonzalez on 10/4/19.
//  Copyright © 2019 Brandon Gonzalez. All rights reserved.
//

import UIKit

class signInViewController: UIViewController {
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTextFields()
        
    }
    
    func setUpTextFields() {
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: mailTextField.frame.height - 1, width: mailTextField.frame.width,    height: 1.0)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        bottomLine.opacity = 40
        mailTextField.borderStyle = UITextField.BorderStyle.none
        mailTextField.layer.addSublayer(bottomLine)
        
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0.0, y: passTextField.frame.height - 1, width: passTextField.frame.width,    height: 1.0)
        bottomLine2.backgroundColor = UIColor.lightGray.cgColor
        bottomLine2.opacity = 40
        passTextField.borderStyle = UITextField.BorderStyle.none
        passTextField.layer.addSublayer(bottomLine2)
        
        
    }

}
