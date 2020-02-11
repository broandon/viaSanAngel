//
//  cuponesTableViewCell.swift
//  viaSanAngel
//
//  Created by Brandon Gonzalez on 20/01/20.
//  Copyright © 2020 Brandon Gonzalez. All rights reserved.
//

import UIKit

class cuponesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imagenDeCupon: UIImageView!
    @IBOutlet weak var typeOfFood: UIImageView!
    @IBOutlet weak var nameOfCoupon: UILabel!
    @IBOutlet weak var textOfCoupon: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
