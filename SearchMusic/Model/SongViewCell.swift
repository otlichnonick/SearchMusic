//
//  SongViewCell.swift
//  SearchMusic
//
//  Created by Антон on 16.09.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit

class SongViewCell: UITableViewCell {
    
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
