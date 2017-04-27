//
//  UserView.swift
//  SAPChart
//
//  Created by Jacopo Mangiavacchi on 27/04/2017.
//  Copyright © 2017 Jacopo. All rights reserved.
//

import UIKit
import Charts

protocol UserViewProtocol {
    func call()
    func message()
}

class UserView: UIView {
    
    @IBOutlet var view: UserView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    var delegate: UserViewProtocol?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let _ = Bundle.main.loadNibNamed("UserView", owner: self, options: nil)?.first as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        let _ = Bundle.main.loadNibNamed("UserView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    @IBAction func callAction(_ sender: Any) {
        delegate?.call()
    }
    
    @IBAction func messageAction(_ sender: Any) {
        delegate?.message()
    }
    
    
    
    
}

