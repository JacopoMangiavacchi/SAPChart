//
//  BoxView.swift
//  SAPChart
//
//  Created by Jacopo Mangiavacchi on 21/04/2017.
//  Copyright © 2017 Jacopo. All rights reserved.
//

import UIKit

@IBDesignable class BoxView : UIView {
    let constSmallFontRatio = CGFloat(2.6)
    
    var centerLabel: UILabel!
    var topLabel: UILabel!

    internal var _fontSize: Int! = 48
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
    }
    
    func addSubviews() {
        centerLabel = UILabel()
        addSubview(centerLabel)
        topLabel = UILabel()
        addSubview(topLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resetLabelsSize()
    }

    internal func resetLabelsSize() {
        centerLabel.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(_fontSize))!
        let fontHeight = centerLabel.font.pointSize
        centerLabel.frame =  CGRect(x: 0.0, y: (bounds.size.height / 2) - (fontHeight / 2), width: bounds.size.width, height: fontHeight)
        centerLabel.textAlignment = .center
        
        topLabel.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(_fontSize) / constSmallFontRatio)!
        topLabel.frame =  CGRect(x: 0.0, y: (centerLabel.frame.origin.y +  centerLabel.frame.size.height), width: bounds.size.width, height: (bounds.size.height - (centerLabel.frame.origin.y +  centerLabel.frame.size.height)))
        topLabel.textAlignment = .center
        topLabel.numberOfLines = 2
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    @IBInspectable var fontSize: Int =  48 {
        didSet {
            _fontSize = fontSize
            resetLabelsSize()
        }
    }

    @IBInspectable var topTextColor: UIColor = UIColor.white {
        didSet {
            topLabel.textColor = topTextColor
        }
    }

    @IBInspectable var centerTextColor: UIColor = UIColor.white {
        didSet {
            centerLabel.textColor = centerTextColor
        }
    }

    @IBInspectable var topText: String = "" {
        didSet {
            topLabel.text = topText
        }
    }

    @IBInspectable var centerText: String = "" {
        didSet {
            centerLabel.text = centerText
        }
    }
}


