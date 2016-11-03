//
//  PokemonMoveCell.swift
//  pokedex3
//
//  Created by Jude Joseph on 10/28/16.
//  Copyright © 2016 Jude Joseph. All rights reserved.
//

import UIKit

class PokemonMoveCell: UITableViewCell {

    @IBOutlet weak var moveNameLbl: UILabel!
    @IBOutlet weak var lvlLearnedLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var powerLbl: UILabel!
    @IBOutlet weak var accuracyLbl: UILabel!
    @IBOutlet weak var ppLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
