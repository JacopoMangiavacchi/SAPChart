//
//  MonthEndViewController.swift
//  SAPChart
//
//  Created by Jacopo Mangiavacchi on 4/10/17.
//  Copyright © 2017 Jacopo. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON


class MonthEndViewController: UIViewController, UIScrollViewDelegate, ChartViewDelegate, IAxisValueFormatter {

    @IBOutlet weak var ppChart: PieChartView!
    @IBOutlet weak var fpChart: PieChartView!
    @IBOutlet weak var cpChart: PieChartView!
    @IBOutlet weak var ufpChart: PieChartView!
    @IBOutlet weak var saChart: PieChartView!
    
    @IBOutlet weak var segmentControlView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControlView: UIView!
    
    @IBOutlet weak var groupSelectionSegment: UISegmentedControl!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var currentMonthView: CurrentMonthView!
    var diagnosticsView: UIView!
    
    var scrollAreaWidth:CGFloat = 0.0
    var scrollAreaHeight:CGFloat = 0.0
    
    var jsonData: JSON!
    var selectedDivision: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        jsonData = appDelegate.jsonData
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollAreaWidth = scrollView.superview!.frame.width
        scrollAreaHeight = scrollView.superview!.frame.height - segmentControlView.frame.height - pageControlView.frame.height
        
        currentMonthView = CurrentMonthView(frame: CGRect(x: 0, y: 0, width: scrollAreaWidth, height: scrollAreaHeight))
        diagnosticsView = UIView(frame: CGRect(x: scrollAreaWidth, y: 0, width: scrollAreaWidth, height: scrollAreaHeight))
        diagnosticsView.backgroundColor = Constants.whiteColor
        
        scrollView.addSubview(currentMonthView)
        scrollView.addSubview(diagnosticsView)
        
        scrollView.contentSize = CGSize(width: scrollAreaWidth * 2, height: scrollAreaHeight)
        
        configPieChart(ppChart, label: "\(jsonData["divisionStatus"]["PP"]["completition"].intValue)%")
        configPieChart(fpChart, label: "\(jsonData["divisionStatus"]["FP"]["completition"].intValue)%")
        configPieChart(cpChart, label: "\(jsonData["divisionStatus"]["CP"]["completition"].intValue)%")
        configPieChart(ufpChart, label: "\(jsonData["divisionStatus"]["UFP"]["completition"].intValue)%")
        configPieChart(saChart, label: "\(jsonData["divisionStatus"]["SA"]["completition"].intValue)%")
        
        configBarChart(currentMonthView.groupAccountingChart)
        
        currentMonthView.dayOfMonthLabel.text = jsonData["globalMonthValues"]["dayOfMonthLabel"].stringValue
        currentMonthView.ticketsOpenedLabel.text = jsonData["globalMonthValues"]["ticketsOpenedLabel"].stringValue
        currentMonthView.ticketClosedLabel.text = jsonData["globalMonthValues"]["ticketClosedLabel"].stringValue
        currentMonthView.ticketMissedLabel.text = jsonData["globalMonthValues"]["ticketMissedLabel"].stringValue
        currentMonthView.completitionLabel.text = jsonData["globalMonthValues"]["completitionLabel"].stringValue
    }
    

    override func viewDidAppear(_ animated: Bool) {
        ppChart.clear()
        fpChart.clear()
        cpChart.clear()
        ufpChart.clear()
        saChart.clear()
        currentMonthView.groupAccountingChart.clear()
        
        updatePieChartWithData(ppChart, value: jsonData["divisionStatus"]["PP"]["completition"].intValue)
        updatePieChartWithData(fpChart, value: jsonData["divisionStatus"]["FP"]["completition"].intValue)
        updatePieChartWithData(cpChart, value: jsonData["divisionStatus"]["CP"]["completition"].intValue)
        updatePieChartWithData(ufpChart, value: jsonData["divisionStatus"]["UFP"]["completition"].intValue)
        updatePieChartWithData(saChart, value: jsonData["divisionStatus"]["SA"]["completition"].intValue)
        
        updateBarChart(currentMonthView.groupAccountingChart)

        ppChart.animate(xAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
        fpChart.animate(xAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
        cpChart.animate(xAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
        ufpChart.animate(xAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
        saChart.animate(xAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
        
        currentMonthView.groupAccountingChart.animate(yAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        pieChartView.highlightPerTapEnabled = true
        
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
        
        horizontalBarChartView.highlightPerTapEnabled = false
        
        horizontalBarChartView.chartDescription?.text = nil
        horizontalBarChartView.legend.setCustom(entries: [])
        
        
        horizontalBarChartView.drawGridBackgroundEnabled = false
        horizontalBarChartView.dragEnabled = false
        horizontalBarChartView.setScaleEnabled(false)
        horizontalBarChartView.pinchZoomEnabled = false
        horizontalBarChartView.xAxis.labelPosition = .bottom
        horizontalBarChartView.xAxis.labelTextColor  = UIColor.black
        horizontalBarChartView.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 16.0)!
        horizontalBarChartView.xAxis.labelCount = 5
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
        
        let currentMonth = jsonData["groupStatus"]["Month"].intValue
        let sixMonth = jsonData["groupStatus"]["6Months"].intValue
        let averageYear = jsonData["groupStatus"]["Avg1Y"].intValue
        
        let dataEntries = [BarChartDataEntry(x: 1.0, yValues: [Double(averageYear), Double(100-averageYear)]),
                           BarChartDataEntry(x: 2.0, yValues: [Double(sixMonth), Double(100-sixMonth)]),
                           BarChartDataEntry(x: 3.0, yValues: [Double(currentMonth), Double(100-currentMonth)])]
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
        
        chartDataSet.colors = [Constants.darkColor, Constants.lightColor]
        chartDataSet.drawValuesEnabled = false
        
        let chartData = BarChartData(dataSet: chartDataSet)
        horizontalBarChartView.data = chartData
    }
    

    @IBAction func onPublish(_ sender: Any) {
        print("Publish")
    }
    
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        switch chartView {
        case ppChart:
            selectedDivision = "PP"
        case fpChart:
            selectedDivision = "FP"
        case cpChart:
            selectedDivision = "CP"
        case ufpChart:
            selectedDivision = "UFP"
        case saChart:
            selectedDivision = "SA"
        default:
            selectedDivision = nil
        }
        
        performSegue(withIdentifier: "showPlantDetails", sender: nil)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlantDetails" {
            let vc: PlantDetailViewController = segue.destination as! PlantDetailViewController
            vc.jsonData = jsonData
            vc.selectedDivision = selectedDivision!
        }
    }

    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        let intValue = Int(round(value))
        
        switch intValue {
        case 1:
            return " Average One Year    "
        case 2:
            return " Last Six Months    "
        case 3:
            return " Current Month    "
        default:
            return ""
        }
    }

    
    @IBAction func onChangingGroupSelection(_ sender: Any) {
        switch groupSelectionSegment.selectedSegmentIndex {
        case 0:
            pageControl.currentPage = 0
            currentMonthView.groupAccountingChart.animate(yAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
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
            //currentMonthView.groupAccountingChart.animate(yAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
        }
        else {
            pageControl.currentPage = 1
            groupSelectionSegment.selectedSegmentIndex = 1
        }
    }

}
