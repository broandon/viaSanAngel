//
//  tiendasTableViewCell.swift
//  viaSanAngel
//
//  Created by Brandon Gonzalez on 16/01/20.
//  Copyright © 2020 Brandon Gonzalez. All rights reserved.
//

import UIKit
import SDWebImage

class tiendasTableViewCell: UITableViewCell {
    
    @IBOutlet weak var logoTienda: UIImageView!
    @IBOutlet weak var imagenComida: UIImageView!
    @IBOutlet weak var thisOneView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("Initiated")
        thisOneView.layer.borderWidth = 2
        thisOneView.layer.borderColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00).cgColor
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
