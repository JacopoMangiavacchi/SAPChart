//
//  Constants.swift
//  SAPChart
//
//  Created by Jacopo Mangiavacchi on 4/12/17.
//  Copyright © 2017 Jacopo. All rights reserved.
//

import UIKit

struct Constants {

    static let darkColor = UIColor(red: 50/255.0, green: 49/255.0, blue: 49/255.0, alpha: 1.0)
    static let lightColor = UIColor(red: 218/255.0, green: 218/255.0, blue: 218/255.0, alpha: 1.0)
    
    static let orangeColor = UIColor(red: 255/255.0, green: 105/255.0, blue: 1/255.0, alpha: 1.0)
    static let orangeLightColor = UIColor(red: 254/255.0, green: 242/255.0, blue: 231/255.0, alpha: 1.0)

    static let circleDarkColor = UIColor(red: 75/255.0, green: 73/255.0, blue: 73/255.0, alpha: 1.0)
    static let circleLightColor = UIColor(red: 186/255.0, green: 188/255.0, blue: 188/255.0, alpha: 1.0)
    
    static let whiteColor = UIColor.white

    static let meTicketsColorArray = [darkColor, lightColor]
    static let qualityTicketsColorArray = [orangeLightColor, lightColor, darkColor, circleLightColor]
    static let qualityCompletitionColorArray = [lightColor, darkColor]

    static let meTicketsLabelArray = ["Missed SLA", "Tickets"]
    static let qualityTicketsLabelArray = ["Customer", "Vendor", "Jail", "Cost Centres"]
    static let qualityCompletitionLabelArray = ["Current", "Average"]

//    static let barColor1 = UIColor(red: 186/255.0, green: 97/255.0, blue: 37/255.0, alpha: 1.0)
//    static let barColor2 = UIColor(red: 222/255.0, green: 117/255.0, blue: 45/255.0, alpha: 1.0)
//    static let barColor3 = UIColor(red: 240/255.0, green: 153/255.0, blue: 113/255.0, alpha: 1.0)
//    static let barColor4 = UIColor(red: 245/255.0, green: 194/255.0, blue: 176/255.0, alpha: 1.0)
    
    static let animationTime = 1.5

    static let divisions = ["PP" : "Packaging Paper", "FP" : "Fibre Packaging", "CP" : "Consumer Packaging", "UFP" : "Uncoated Fine Paper", "SA" : "South Africa Division"]
    static let boxesLabel = ["dayOfMonthLabel" : "DAY\n", "ticketsOpenedLabel" : "OPENED\n", "ticketClosedLabel" : "CLOSED\n", "ticketMissedLabel" : "MISSED\n", "completitionLabel" : "COMPLETED"]
}
