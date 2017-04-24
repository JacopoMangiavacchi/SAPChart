//
//  DiagnosticView.swift
//  SAPChart
//
//  Created by Jacopo Mangiavacchi on 21/04/2017.
//  Copyright © 2017 Jacopo. All rights reserved.
//

import UIKit
import Charts

class DiagnosticView: UIView {
    
    @IBOutlet var view: DiagnosticView!

    @IBOutlet weak var ticketsLineChartView: LineChartView!
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let _ = Bundle.main.loadNibNamed("DiagnosticView", owner: self, options: nil)?.first as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        let _ = Bundle.main.loadNibNamed("DiagnosticView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
}


