//
//  eventosTableViewCell.swift
//  viaSanAngel
//
//  Created by Brandon Gonzalez on 10/02/20.
//  Copyright © 2020 Brandon Gonzalez. All rights reserved.
//

import UIKit

class eventosTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var imageEvent: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
