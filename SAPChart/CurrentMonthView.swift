//
//  CurrentMonthView.swift
//  SAPChart
//
//  Created by Jacopo Mangiavacchi on 4/19/17.
//  Copyright © 2017 Jacopo. All rights reserved.
//

import UIKit
import Charts

class CurrentMonthView: UIView {
    
    @IBOutlet var view: CurrentMonthView!

    @IBOutlet weak var groupAccountingChart: HorizontalBarChartView!

    @IBOutlet weak var dayOfMonthBox: BoxView!
    @IBOutlet weak var ticketsOpenedBox: BoxView!
    @IBOutlet weak var ticketClosedBox: BoxView!
    @IBOutlet weak var ticketMissedBox: BoxView!
    @IBOutlet weak var completedPieChart: PieChartView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let _ = Bundle.main.loadNibNamed("CurrentMonthView", owner: self, options: nil)?.first as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        let _ = Bundle.main.loadNibNamed("CurrentMonthView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
}


