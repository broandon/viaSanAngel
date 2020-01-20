//
//  cuponesTableViewCell.swift
//  viaSanAngel
//
//  Created by Brandon Gonzalez on 20/01/20.
//  Copyright © 2020 Brandon Gonzalez. All rights reserved.
//

import UIKit

class cuponesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imagenCupon: UIImageView!
    @IBOutlet weak var tituloCupon: UILabel!
    @IBOutlet weak var thisOtherView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        print("initiated coupoms")
        thisOtherView.layer.borderWidth = 2
        thisOtherView.layer.borderColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00).cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
