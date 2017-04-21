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

extension UIDevice {
    static var isSimulator: Bool {
        return ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
    }
}

class PlantDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, ChartViewDelegate, IAxisValueFormatter {
    
    @IBOutlet weak var plantPieChart: PieChartView!
    @IBOutlet weak var pieChartLabel: UILabel!
    
    @IBOutlet weak var segmentControlView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControlView: UIView!
    
    @IBOutlet weak var groupSelectionSegment: UISegmentedControl!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var ticketsOpenedBox: BoxView!
    @IBOutlet weak var ticketClosedBox: BoxView!
    @IBOutlet weak var ticketMissedBox: BoxView!
    @IBOutlet weak var completitionBox: BoxView!
    
    @IBOutlet weak var user1ImageView: UIImageView!
    @IBOutlet weak var user2ImageView: UIImageView!
    
    
    var plantsView: PlantsView!
    var diagnosticsView: DiagnosticView!
    
    var scrollAreaWidth:CGFloat = 0.0
    var scrollAreaHeight:CGFloat = 0.0
    
    
    var jsonData: JSON!
    var selectedDivision: String!
    var numPlants:Int = 0
    var plantMessages:[JSON]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ticketsOpenedBox.topLabel.text = Constants.boxesLabel["ticketsOpenedLabel"]
        ticketClosedBox.topLabel.text = Constants.boxesLabel["ticketClosedLabel"]
        ticketMissedBox.topLabel.text = Constants.boxesLabel["ticketMissedLabel"]
        completitionBox.topLabel.text = Constants.boxesLabel["completitionLabel"]
        
        ticketsOpenedBox.centerLabel.text = jsonData["divisionStatus"][selectedDivision]["monthValues"]["ticketsOpenedLabel"].stringValue
        ticketClosedBox.centerLabel.text = jsonData["divisionStatus"][selectedDivision]["monthValues"]["ticketClosedLabel"].stringValue
        ticketMissedBox.centerLabel.text = jsonData["divisionStatus"][selectedDivision]["monthValues"]["ticketMissedLabel"].stringValue
        completitionBox.centerLabel.text = jsonData["divisionStatus"][selectedDivision]["monthValues"]["completitionLabel"].stringValue
}
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollAreaWidth = scrollView.superview!.frame.width
        scrollAreaHeight = scrollView.superview!.frame.height - segmentControlView.frame.height - pageControlView.frame.height
        
        plantsView = PlantsView(frame: CGRect(x: 0, y: 0, width: scrollAreaWidth, height: scrollAreaHeight))
        plantsView.tableView.delegate = self
        plantsView.tableView.dataSource = self
        plantsView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "messageCell")

        diagnosticsView = DiagnosticView(frame: CGRect(x: scrollAreaWidth, y: 0, width: scrollAreaWidth, height: scrollAreaHeight))
        
        scrollView.addSubview(plantsView)
        scrollView.addSubview(diagnosticsView)
        
        scrollView.contentSize = CGSize(width: scrollAreaWidth * 2, height: scrollAreaHeight)
        
        pieChartLabel.text = Constants.divisions[selectedDivision]
        numPlants = jsonData["divisionStatus"][selectedDivision]["plants"].array!.count
        
        configPieChart(plantPieChart, label: "\(jsonData["divisionStatus"][selectedDivision]["completition"].intValue)%")
        
        configBarChart(plantsView.plantsBarChart)
        
        updatePieChartWithData(plantPieChart, value: jsonData["divisionStatus"][selectedDivision]["completition"].intValue)
        
        updateBarChart(plantsView.plantsBarChart)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        plantPieChart.animate(xAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
        plantsView.plantsBarChart.animate(yAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
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
            if !UIDevice.isSimulator {
                let mailVC = MFMailComposeViewController()
                
                mailVC.mailComposeDelegate = self
                
                // Configure the fields of the interface.
                mailVC.setToRecipients([])
                mailVC.setSubject("")
                mailVC.setMessageBody("", isHTML: false)
                
                self.present(mailVC, animated: false, completion: nil)
            }
            else {
                print("No Mail on Simulator")
            }
        }
        actionSheetController.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Via iMessage", style: .default) { action -> Void in
            if !UIDevice.isSimulator {
                let messageVC = MFMessageComposeViewController()
                
                messageVC.body = "";
                messageVC.recipients = []
                messageVC.messageComposeDelegate = self;
                
                self.present(messageVC, animated: false, completion: nil)
            }
            else {
                print("No iMessage on Simulator")
            }
        }
        actionSheetController.addAction(deleteActionButton)
        
        // We need to provide a popover sourceView when using it on iPad
        actionSheetController.popoverPresentationController?.sourceView = sender as? UIView
        actionSheetController.popoverPresentationController?.sourceRect = CGRect(x: (sender as! UIView).bounds.midX, y: (sender as! UIView).bounds.midY, width: 0, height: 0)
        
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
        pieChartView.holeColor = UIColor.clear
        pieChartView.rotationAngle = 270.0
        pieChartView.rotationEnabled = true
        pieChartView.highlightPerTapEnabled = false
        
        pieChartView.chartDescription?.text = nil
        
        pieChartView.drawCenterTextEnabled = true
        //pieChartView.centerText = label
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
        paragraphStyle.alignment = .center
        
        let attrString = NSMutableAttributedString(string: label)
        attrString.setAttributes([
            NSForegroundColorAttributeName: NSUIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 32.0)!,
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
        horizontalBarChartView.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 16.0)!
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
    
    
    internal func updatePieChartWithData(_ pieChartView: PieChartView, value: Int) {
        let dataEntries = [PieChartDataEntry(value: Double(value), label: ""), PieChartDataEntry(value: Double(100-value), label: "")]
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "")
        
        chartDataSet.sliceSpace = 2.0
        chartDataSet.colors = [Constants.whiteColor, Constants.lightColor]
        chartDataSet.drawValuesEnabled = false
        
        let chartData = PieChartData(dataSet: chartDataSet)
        pieChartView.data = chartData
    }
    
    
    internal func updateBarChart(_ horizontalBarChartView: HorizontalBarChartView) {
        var dataEntries: [BarChartDataEntry] = []

        if let plantsArray = jsonData["divisionStatus"][selectedDivision]["plants"].array?.reversed() {
            var plantX = Double(1)
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
        if chartView == plantsView.plantsBarChart {
            plantsView.rightBackgroundLabel.isHidden = true
            plantsView.tableView.isHidden = false

            plantMessages = nil
            animateTableView()
            
            let plantSelected = numPlants - Int(entry.x)
            
            if let messagesArray = jsonData["divisionStatus"][selectedDivision]["plants"][plantSelected]["messages"].array {
                plantMessages = messagesArray
            }

            user1ImageView.image = UIImage(named: "3.png")
            user2ImageView.image = UIImage(named: "4.png")
            
            animateTableView()
        }
    }
    
    internal func animateTableView() {
        let range = NSMakeRange(0, plantsView.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        plantsView.tableView.reloadSections(sections as IndexSet, with: .automatic)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        if chartView == plantsView.plantsBarChart {
            plantsView.rightBackgroundLabel.isHidden = false
            plantsView.tableView.isHidden = true

            user1ImageView.image = UIImage(named: "1.png")
            user2ImageView.image = UIImage(named: "2.png")
        }
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    
        let intValue = Int(round(value))
        
        if intValue > 0 && intValue <= numPlants {
            return jsonData["divisionStatus"][selectedDivision]["plants"][numPlants - intValue]["name"].stringValue
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


    @IBAction func onChangingGroupSelection(_ sender: Any) {
        switch groupSelectionSegment.selectedSegmentIndex {
        case 0:
            pageControl.currentPage = 0
            plantsView.plantsBarChart.animate(yAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        case 1:
            pageControl.currentPage = 1
            scrollView.setContentOffset(CGPoint(x: scrollAreaWidth, y: 0), animated: true)
        default:
            print("wrong!")
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 {
            pageControl.currentPage = 0
            groupSelectionSegment.selectedSegmentIndex = 0
            //plantsView.plantsBarChart.animate(yAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
        }
        else {
            pageControl.currentPage = 1
            groupSelectionSegment.selectedSegmentIndex = 1
        }
    }
}


