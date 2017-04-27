//
//  PlantsViewCell.swift
//  SAPChart
//
//  Created by Jacopo Mangiavacchi on 27/04/2017.
//  Copyright © 2017 Jacopo. All rights reserved.
//

import UIKit
import Charts

class PlantsViewCell: UITableViewCell {

    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var plantNotesLabel: UILabel!
    @IBOutlet weak var horizonalBarView: HorizontalBarChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
