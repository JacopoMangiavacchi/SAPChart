//
//  PlantsView.swift
//  SAPChart
//
//  Created by Jacopo Mangiavacchi on 4/20/17.
//  Copyright © 2017 Jacopo. All rights reserved.
//

import UIKit
import Charts

class PlantsView: UIView {
    
    @IBOutlet var view: PlantsView!
    
    @IBOutlet weak var tableView: UITableView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let _ = Bundle.main.loadNibNamed("PlantsView", owner: self, options: nil)?.first as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        let _ = Bundle.main.loadNibNamed("PlantsView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
}


