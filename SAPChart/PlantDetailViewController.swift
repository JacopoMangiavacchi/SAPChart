//
//  PlantDetailViewController.swift
//  SAPChart
//
//  Created by Jacopo Mangiavacchi on 4/12/17.
//  Copyright © 2017 Jacopo. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON
import MessageUI


class PlantDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, ChartViewDelegate, IAxisValueFormatter {
    
    @IBOutlet weak var plantPieChart: PieChartView!
    
    @IBOutlet weak var plantsBarChart: HorizontalBarChartView!
    
    @IBOutlet weak var rightBackgroundLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var jsonData: JSON!
    var plant: String!
    var numPlants:Int = 0
    var plantMessages:[JSON]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        numPlants = jsonData["plantStatus"][plant]["plants"].array!.count
        
        configPieChart(plantPieChart, label: plant)
        
        configBarChart(plantsBarChart)
        
        updatePieChartWithData(plantPieChart, value: jsonData["plantStatus"][plant]["completition"].intValue, label: plant)
        
        updateBarChart(plantsBarChart)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        plantPieChart.animate(xAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
        plantsBarChart.animate(yAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAction(_ sender: Any) {
        // Create the AlertController and add its actions like button in ActionSheet
        let actionSheetController = UIAlertController(title: "Please select", message: "Take Actions", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Via Email", style: .default) { action -> Void in
            let mailVC = MFMailComposeViewController()
            
            mailVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            mailVC.setToRecipients([])
            mailVC.setSubject("")
            mailVC.setMessageBody("", isHTML: false)
            
            self.present(mailVC, animated: false, completion: nil)
        }
        actionSheetController.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Via iMessage", style: .default) { action -> Void in
            let messageVC = MFMessageComposeViewController()
            
            messageVC.body = "";
            messageVC.recipients = []
            messageVC.messageComposeDelegate = self;
            
            self.present(messageVC, animated: false, completion: nil)
        }
        actionSheetController.addAction(deleteActionButton)
        
        // We need to provide a popover sourceView when using it on iPad
        actionSheetController.popoverPresentationController?.sourceView = (sender as! UIBarButtonItem).value(forKey: "view") as? UIView
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    internal func configPieChart(_ pieChartView: PieChartView, label: String) {
        pieChartView.delegate = self
        
        pieChartView.entryLabelColor = UIColor.white
        pieChartView.entryLabelFont = UIFont(name: "HelveticaNeue-Light", size: 20.0)
        
        pieChartView.usePercentValuesEnabled = true
        pieChartView.drawSlicesUnderHoleEnabled = false
        pieChartView.holeRadiusPercent = 0.58
        pieChartView.transparentCircleRadiusPercent = 0.61
        pieChartView.setExtraOffsets(left: 5.0, top: 10.0, right: 5.0, bottom: 5.0)
        pieChartView.drawHoleEnabled = true
        pieChartView.rotationAngle = 270.0
        pieChartView.rotationEnabled = true
        pieChartView.highlightPerTapEnabled = true
        
        pieChartView.chartDescription?.text = nil
        
        pieChartView.drawCenterTextEnabled = true
        //pieChartView.centerText = label
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
        paragraphStyle.alignment = .center
        
        let attrString = NSMutableAttributedString(string: label)
        attrString.setAttributes([
            NSForegroundColorAttributeName: NSUIColor.black,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20.0)!,
            NSParagraphStyleAttributeName: paragraphStyle
            ], range: NSMakeRange(0, attrString.length))
        
        pieChartView.centerAttributedText = attrString
        
        pieChartView.legend.setCustom(entries: [])
    }
    
    
    internal func configBarChart(_ horizontalBarChartView: HorizontalBarChartView) {
        horizontalBarChartView.delegate = self
        
        horizontalBarChartView.highlightPerTapEnabled = true
        
        horizontalBarChartView.chartDescription?.text = nil
        horizontalBarChartView.legend.setCustom(entries: [])
        
        
        horizontalBarChartView.drawGridBackgroundEnabled = false
        horizontalBarChartView.dragEnabled = false
        horizontalBarChartView.setScaleEnabled(false)
        horizontalBarChartView.pinchZoomEnabled = false
        horizontalBarChartView.xAxis.labelPosition = .bottom
        horizontalBarChartView.xAxis.labelTextColor  = UIColor.black
        horizontalBarChartView.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 14.0)!
        horizontalBarChartView.xAxis.labelCount = numPlants + 2
        horizontalBarChartView.xAxis.drawLabelsEnabled = true
        horizontalBarChartView.xAxis.drawAxisLineEnabled = true
        horizontalBarChartView.xAxis.drawGridLinesEnabled = false
        horizontalBarChartView.xAxis.granularity = 10.0
        horizontalBarChartView.xAxis.valueFormatter = self
        horizontalBarChartView.xAxis.forceLabelsEnabled = true
        
        horizontalBarChartView.drawBarShadowEnabled = false
        horizontalBarChartView.drawValueAboveBarEnabled = false
        horizontalBarChartView.maxVisibleCount = 100;
        
        horizontalBarChartView.leftAxis.enabled = true
        horizontalBarChartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 10, weight: UIFontWeightLight)
        horizontalBarChartView.leftAxis.drawAxisLineEnabled = true
        horizontalBarChartView.leftAxis.drawGridLinesEnabled = true
        horizontalBarChartView.leftAxis.axisMinimum = 0.0 // this replaces startAtZero = YES
        horizontalBarChartView.leftAxis.axisMaximum = 100.0
        
        horizontalBarChartView.rightAxis.enabled = true
        horizontalBarChartView.rightAxis.labelFont = UIFont.systemFont(ofSize: 10, weight: UIFontWeightLight)
        horizontalBarChartView.rightAxis.drawAxisLineEnabled = true
        horizontalBarChartView.rightAxis.drawGridLinesEnabled = false
        horizontalBarChartView.rightAxis.axisMinimum = 0.0 // this replaces startAtZero = YES
        horizontalBarChartView.rightAxis.axisMaximum = 100.0
        
        horizontalBarChartView.fitBars = true
    }
    
    
    internal func updatePieChartWithData(_ pieChartView: PieChartView, value: Int, label: String) {
        let dataEntries = [PieChartDataEntry(value: Double(value), label: "\(value)%"), PieChartDataEntry(value: Double(100-value), label: "\(100-value)%")]
        let chartDataSet = PieChartDataSet(values: dataEntries, label: label)
        
        chartDataSet.sliceSpace = 2.0
        chartDataSet.colors = [Constants.darkColor, Constants.lightColor]
        chartDataSet.drawValuesEnabled = false
        
        let chartData = PieChartData(dataSet: chartDataSet)
        pieChartView.data = chartData
    }
    
    
    internal func updateBarChart(_ horizontalBarChartView: HorizontalBarChartView) {
        var dataEntries: [BarChartDataEntry] = []

        if let plantsArray = jsonData["plantStatus"][plant]["plants"].array {
            var plantX = Double(1.0)
            for plantJson in plantsArray {
                let value = plantJson["completition"].intValue
                dataEntries.append(BarChartDataEntry(x: plantX, yValues: [Double(value), Double(100-value)]))
                plantX += Double(1.0)
            }
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
        
        chartDataSet.colors = [Constants.darkColor, Constants.lightColor]
        chartDataSet.drawValuesEnabled = false
        
        let chartData = BarChartData(dataSet: chartDataSet)
        horizontalBarChartView.data = chartData
    }
    
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if chartView == plantsBarChart {
            rightBackgroundLabel.isHidden = true
            tableView.isHidden = false

            plantMessages = nil
            animateTableView()
            
            if let messagesArray = jsonData["plantStatus"][plant]["plants"][Int(entry.x)-1]["messages"].array {
                plantMessages = messagesArray
            }

            animateTableView()
        }
    }
    
    internal func animateTableView() {
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        tableView.reloadSections(sections as IndexSet, with: .automatic)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        if chartView == plantsBarChart {
            rightBackgroundLabel.isHidden = false
            tableView.isHidden = true
        }
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    
        let intValue = Int(round(value))
        
        if intValue > 0 && intValue <= numPlants {
            return jsonData["plantStatus"][plant]["plants"][intValue-1]["name"].stringValue
            //return " Plant \(intValue)  "
        }
        
        return ""
        
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantMessages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        
        cell.textLabel?.text = plantMessages?[indexPath.row].stringValue ?? ""
        
        return cell
    }
    
    // MARK: - Table view data source

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case .failed:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case .sent:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch (result) {
        case .cancelled:
            print("Mail was cancelled")
            self.dismiss(animated: true, completion: nil)
        case .saved:
            print("Mail saved")
            self.dismiss(animated: true, completion: nil)
        case .failed:
            print("Mail failed")
            self.dismiss(animated: true, completion: nil)
        case .sent:
            print("Mail was sent")
            self.dismiss(animated: true, completion: nil)
        }
    }
}
