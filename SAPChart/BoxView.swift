//
//  BoxView.swift
//  SAPChart
//
//  Created by Jacopo Mangiavacchi on 21/04/2017.
//  Copyright © 2017 Jacopo. All rights reserved.
//

import UIKit

class BoxView: UIView {
    
    @IBOutlet var view: BoxView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var centerLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let _ = Bundle.main.loadNibNamed("BoxView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        let _ = Bundle.main.loadNibNamed("BoxView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
}


