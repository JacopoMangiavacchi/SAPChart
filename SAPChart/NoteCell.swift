//
//  NoteCell.swift
//  SAPChart
//
//  Created by Jacopo Mangiavacchi on 28/04/2017.
//  Copyright © 2017 Jacopo. All rights reserved.
//

import UIKit
import Charts

class NoteCell: UITableViewCell {

    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
