//
//  HighscoreCell.swift
//  Curves2
//
//  Created by Sebastian Haußmann on 11.07.16.
//  Copyright © 2016 Moritz Martin. All rights reserved.
//

import UIKit

class HighscoreCell:UITableViewCell {
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
