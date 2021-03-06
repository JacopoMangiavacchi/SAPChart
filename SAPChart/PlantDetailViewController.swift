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

class PlantDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, DiagnosticProtocol, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UserViewProtocol, UIPopoverPresentationControllerDelegate {
    
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
    
    @IBOutlet weak var user1ImageView: UIImageView!
    @IBOutlet weak var user2ImageView: UIImageView!
    @IBOutlet weak var userView1: UserView!
    @IBOutlet weak var userView2: UserView!
    
    
    var plantsView: PlantsView!
    var diagnosticsView: DiagnosticView!
    
    var scrollAreaWidth:CGFloat = 0.0
    var scrollAreaHeight:CGFloat = 0.0
    
    
    var jsonData: JSON!
    var selectedDivision: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _setDivisionUsers()
        
        ticketsOpenedBox.topLabel.text = Constants.boxesLabel["ticketsOpenedLabel"]
        ticketClosedBox.topLabel.text = Constants.boxesLabel["ticketClosedLabel"]
        ticketMissedBox.topLabel.text = Constants.boxesLabel["ticketMissedLabel"]
        
        ticketsOpenedBox.centerLabel.text = jsonData["divisionStatus"][selectedDivision]["monthValues"]["ticketsOpenedLabel"].stringValue
        ticketClosedBox.centerLabel.text = jsonData["divisionStatus"][selectedDivision]["monthValues"]["ticketClosedLabel"].stringValue
        ticketMissedBox.centerLabel.text = jsonData["divisionStatus"][selectedDivision]["monthValues"]["ticketMissedLabel"].stringValue
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollAreaWidth = scrollView.superview!.frame.width
        scrollAreaHeight = scrollView.superview!.frame.height - segmentControlView.frame.height - pageControlView.frame.height
        
        plantsView = PlantsView(frame: CGRect(x: 0, y: 0, width: scrollAreaWidth, height: scrollAreaHeight))
        plantsView.tableView.delegate = self
        plantsView.tableView.dataSource = self
        plantsView.tableView.register(UINib(nibName: "PlantsViewCell", bundle: nil), forCellReuseIdentifier: "PlantsViewCell")

        diagnosticsView = DiagnosticView(frame: CGRect(x: scrollAreaWidth, y: 0, width: scrollAreaWidth, height: scrollAreaHeight))
        
        scrollView.addSubview(plantsView)
        scrollView.addSubview(diagnosticsView)
        
        scrollView.contentSize = CGSize(width: scrollAreaWidth * 2, height: scrollAreaHeight)
        
        //pieChartLabel.text = Constants.divisions[selectedDivision]
        self.title = Constants.divisions[selectedDivision]
        
        configPieChart(plantPieChart, enableTouch: false, label: "\(jsonData["divisionStatus"][selectedDivision]["completition"].intValue)%", labelFontSize: 48.0, labelFontColor: NSUIColor.white)
        
        updatePieChartWithData(plantPieChart, value: jsonData["divisionStatus"][selectedDivision]["completition"].intValue)
        
        configCharts(diagnosticsView: diagnosticsView)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        plantPieChart.animate(xAxisDuration: Constants.animationTime, easingOption: .easeOutBack)

        updateChart(diagnosticsView: diagnosticsView, animated: animated, json: jsonData["globalDiagnostics"])
        animateChart(diagnosticsView: diagnosticsView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    @IBAction func onAction(_ sender: Any) {
//        // Create the AlertController and add its actions like button in ActionSheet
//        let actionSheetController = UIAlertController(title: "Please select", message: "Take Actions", preferredStyle: .actionSheet)
//        
//        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
//            print("Cancel")
//        }
//        actionSheetController.addAction(cancelActionButton)
//        
//        let saveActionButton = UIAlertAction(title: "Via Email", style: .default) { action -> Void in
//            if !UIDevice.isSimulator {
//                let mailVC = MFMailComposeViewController()
//                
//                mailVC.mailComposeDelegate = self
//                
//                // Configure the fields of the interface.
//                mailVC.setToRecipients([])
//                mailVC.setSubject("")
//                mailVC.setMessageBody("", isHTML: false)
//                
//                self.present(mailVC, animated: false, completion: nil)
//            }
//            else {
//                print("No Mail on Simulator")
//            }
//        }
//        actionSheetController.addAction(saveActionButton)
//        
//        let deleteActionButton = UIAlertAction(title: "Via iMessage", style: .default) { action -> Void in
//            if !UIDevice.isSimulator {
//                let messageVC = MFMessageComposeViewController()
//                
//                messageVC.body = "";
//                messageVC.recipients = []
//                messageVC.messageComposeDelegate = self;
//                
//                self.present(messageVC, animated: false, completion: nil)
//            }
//            else {
//                print("No iMessage on Simulator")
//            }
//        }
//        actionSheetController.addAction(deleteActionButton)
//        
//        // We need to provide a popover sourceView when using it on iPad
//        actionSheetController.popoverPresentationController?.sourceView = sender as? UIView
//        actionSheetController.popoverPresentationController?.sourceRect = CGRect(x: (sender as! UIView).bounds.midX, y: (sender as! UIView).bounds.midY, width: 0, height: 0)
//        
//        self.present(actionSheetController, animated: true, completion: nil)
//    }
    
    
    internal func configPieChart(_ pieChartView: PieChartView, enableTouch: Bool, label: String, labelFontSize: Float, labelFontColor: UIColor) {
        pieChartView.entryLabelColor = UIColor.white
        pieChartView.entryLabelFont = UIFont(name: "HelveticaNeue-Light", size: 20.0)
        
        pieChartView.usePercentValuesEnabled = true
        pieChartView.drawSlicesUnderHoleEnabled = false
        pieChartView.holeRadiusPercent = 0.7
        pieChartView.transparentCircleRadiusPercent = 0.61
        pieChartView.setExtraOffsets(left: 5.0, top: 10.0, right: 5.0, bottom: 5.0)
        pieChartView.drawHoleEnabled = true
        pieChartView.holeColor = UIColor.clear
        pieChartView.rotationAngle = 270.0
        pieChartView.rotationEnabled = false
        pieChartView.highlightPerTapEnabled = enableTouch
        
        pieChartView.chartDescription?.text = nil
        
        pieChartView.drawCenterTextEnabled = true
        //pieChartView.centerText = label
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
        paragraphStyle.alignment = .center
        
        let attrString = NSMutableAttributedString(string: label)
        attrString.setAttributes([
            NSForegroundColorAttributeName: labelFontColor,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: CGFloat(labelFontSize))!,
            NSParagraphStyleAttributeName: paragraphStyle
            ], range: NSMakeRange(0, attrString.length))
        
        pieChartView.centerAttributedText = attrString
        
        pieChartView.legend.setCustom(entries: [])
    }
    
    
    internal func configBarChart(_ horizontalBarChartView: HorizontalBarChartView) {
        horizontalBarChartView.highlightPerTapEnabled = false
        
        horizontalBarChartView.chartDescription?.text = nil
        horizontalBarChartView.legend.setCustom(entries: [])
        
        horizontalBarChartView.drawGridLinesOnTopEnabled = true   //NB: JACOPO: PATCHED Charts Library to draw Grid Line on top (BarLineChartViewBase.swift::draw(_:))
        horizontalBarChartView.drawGridBackgroundEnabled = false
        horizontalBarChartView.dragEnabled = false
        horizontalBarChartView.setScaleEnabled(false)
        horizontalBarChartView.pinchZoomEnabled = false
        horizontalBarChartView.xAxis.drawLabelsEnabled = false
        horizontalBarChartView.xAxis.drawAxisLineEnabled = false
        horizontalBarChartView.xAxis.drawGridLinesEnabled = false
        horizontalBarChartView.xAxis.granularity = 10.0
        
        horizontalBarChartView.drawBarShadowEnabled = false
        horizontalBarChartView.drawValueAboveBarEnabled = false
        horizontalBarChartView.maxVisibleCount = 100;
        
        horizontalBarChartView.leftAxis.enabled = false
        
        horizontalBarChartView.rightAxis.enabled = true
        horizontalBarChartView.rightAxis.drawLabelsEnabled = false
        horizontalBarChartView.rightAxis.drawAxisLineEnabled = true
        horizontalBarChartView.rightAxis.axisLineColor = UIColor.white
        horizontalBarChartView.rightAxis.axisLineWidth = 0.0
        horizontalBarChartView.rightAxis.gridColor = UIColor.white
        horizontalBarChartView.rightAxis.gridLineWidth = 5.0
        horizontalBarChartView.rightAxis.drawGridLinesEnabled = true
        horizontalBarChartView.rightAxis.axisMinimum = -10.0 // this replaces startAtZero = YES
        horizontalBarChartView.rightAxis.axisMaximum = 110.0
        
        //horizontalBarChartView.fitBars = true
    }
    
    
    internal func updatePieChartWithData(_ pieChartView: PieChartView, value: Int) {
        let dataEntries = [PieChartDataEntry(value: Double(value), label: ""), PieChartDataEntry(value: Double(100-value), label: "")]
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "")
        
        chartDataSet.sliceSpace = 2.0
        chartDataSet.colors = [Constants.circleLightColor, Constants.circleDarkColor]
        chartDataSet.drawValuesEnabled = false
        
        let chartData = PieChartData(dataSet: chartDataSet)
        pieChartView.data = chartData
    }

    
    internal func updateBarChart(_ horizontalBarChartView: HorizontalBarChartView, value: Int) {
        let dataEntries = [BarChartDataEntry(x: 0.0, yValues: [Double(value), Double(100-value)])]
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
        
        chartDataSet.colors = [Constants.darkColor, Constants.orangeLightColor]
        chartDataSet.drawValuesEnabled = false
        
        let chartData = BarChartData(dataSet: chartDataSet)
        horizontalBarChartView.data = chartData
    }
    
    
    internal func _setDivisionUsers() {
        userView1.delegate = self
        userView1.imageView.image = UIImage(named: "User1.png")
        userView1.nameLabel.text = "Rob Chan"
        userView1.idLabel.text = "ID XCA657"

        userView2.delegate = self
        userView2.imageView.image = UIImage(named: "User2.png")
        userView2.nameLabel.text = "David Hoffman"
        userView2.idLabel.text = "ID XCA506"
    }
    

    internal func animateTableView() {
        let range = NSMakeRange(0, plantsView.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        plantsView.tableView.reloadSections(sections as IndexSet, with: .automatic)
    }
    
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonData["divisionStatus"][selectedDivision]["plants"].array!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlantsViewCell", for: indexPath) as! PlantsViewCell
        
        cell.plantNameLabel?.text = jsonData["divisionStatus"][selectedDivision]["plants"][indexPath.row]["name"].stringValue
        cell.plantNotesLabel?.text = "\(jsonData["divisionStatus"][selectedDivision]["plants"][indexPath.row]["messages"].array!.count) Notes"
        configBarChart(cell.horizonalBarView)
        updateBarChart(cell.horizonalBarView, value: jsonData["divisionStatus"][selectedDivision]["plants"][indexPath.row]["completition"].intValue)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessageDetailViewController") as! MessageDetailViewController
        
        popController.plantName = jsonData["divisionStatus"][selectedDivision]["plants"][indexPath.row]["name"].stringValue
        popController.notesArray = jsonData["divisionStatus"][selectedDivision]["plants"][indexPath.row]["messages"]
        
        popController.preferredContentSize = CGSize(width: 800, height: 700)

        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.popoverPresentationController?.backgroundColor = Constants.darkColor
        popController.popoverPresentationController?.delegate = self
        
        popController.popoverPresentationController?.sourceView = self.view
        popController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY - 100, width: 0, height: 0)
        
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        
        self.present(popController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        // return UIModalPresentationStyle.FullScreen
        return UIModalPresentationStyle.none
    }
    
    
    func call() {
        UIApplication.shared.open(URL(string: "facetime:\(Constants.facetimeID)")!, options: [:], completionHandler: nil)
    }

    func message() {
        if !UIDevice.isSimulator {
            let messageVC = MFMessageComposeViewController()
            
            messageVC.body = "";
            messageVC.recipients = [Constants.facetimeID]
            messageVC.messageComposeDelegate = self;
            
            self.present(messageVC, animated: false, completion: nil)
        }
        else {
            print("No iMessage on Simulator")
        }
    }
    
    
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
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        case 1:
            pageControl.currentPage = 1
            animateChart(diagnosticsView: diagnosticsView)
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


