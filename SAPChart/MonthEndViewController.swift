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


class MonthEndViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var ppChart: PieChartView!
    @IBOutlet weak var fpChart: PieChartView!
    @IBOutlet weak var cpChart: PieChartView!
    @IBOutlet weak var ufpChart: PieChartView!
    @IBOutlet weak var saChart: PieChartView!
    
    @IBOutlet weak var groupAccountingChart: HorizontalBarChartView!
    
    @IBOutlet weak var publishButton: UIButton!
    
    @IBOutlet weak var groupSelectionSegment: UISegmentedControl!
    
    var jsonData: JSON!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        jsonData = appDelegate.jsonData
        
        configPieChart(ppChart, label: "PP")
        configPieChart(fpChart, label: "FP")
        configPieChart(cpChart, label: "CP")
        configPieChart(ufpChart, label: "UFP")
        configPieChart(saChart, label: "SA")

        configBarChart(groupAccountingChart)
        
        updatePieChartWithData(ppChart, value: jsonData["plantStatus"]["PP"].intValue, label: "PP")
        updatePieChartWithData(fpChart, value: jsonData["plantStatus"]["FP"].intValue, label: "FP")
        updatePieChartWithData(cpChart, value: jsonData["plantStatus"]["CP"].intValue, label: "CP")
        updatePieChartWithData(ufpChart, value: jsonData["plantStatus"]["UFP"].intValue, label: "UFP")
        updatePieChartWithData(saChart, value: jsonData["plantStatus"]["SA"].intValue, label: "SA")

        updateBarChartWithData(groupAccountingChart, value: jsonData["groupStatus"]["Month"].intValue)
    }

    override func viewDidAppear(_ animated: Bool) {
        ppChart.animate(xAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
        fpChart.animate(xAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
        cpChart.animate(xAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
        ufpChart.animate(xAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
        saChart.animate(xAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
        
        groupAccountingChart.animate(yAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
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
        pieChartView.rotationAngle = 0.0
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

    
    internal func configBarChart(_ HorizontalBarChartView: HorizontalBarChartView) {
        HorizontalBarChartView.delegate = self
        
        HorizontalBarChartView.highlightPerTapEnabled = false
        
        HorizontalBarChartView.chartDescription?.text = nil
        HorizontalBarChartView.legend.setCustom(entries: [])
        
        
        HorizontalBarChartView.drawGridBackgroundEnabled = false
        HorizontalBarChartView.dragEnabled = false
        HorizontalBarChartView.setScaleEnabled(false)
        HorizontalBarChartView.pinchZoomEnabled = false
        HorizontalBarChartView.xAxis.labelPosition = .top
        HorizontalBarChartView.xAxis.labelTextColor  = UIColor.white
        HorizontalBarChartView.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 16.0)!
        HorizontalBarChartView.xAxis.drawAxisLineEnabled = true
        HorizontalBarChartView.xAxis.drawGridLinesEnabled = false
        HorizontalBarChartView.xAxis.granularity = 10.0

        HorizontalBarChartView.drawBarShadowEnabled = false
        HorizontalBarChartView.drawValueAboveBarEnabled = false
        HorizontalBarChartView.maxVisibleCount = 100;
        
        HorizontalBarChartView.leftAxis.enabled = true
        HorizontalBarChartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 10, weight: UIFontWeightLight)
        HorizontalBarChartView.leftAxis.drawAxisLineEnabled = true
        HorizontalBarChartView.leftAxis.drawGridLinesEnabled = true
        HorizontalBarChartView.leftAxis.axisMinimum = 0.0 // this replaces startAtZero = YES
        HorizontalBarChartView.leftAxis.axisMaximum = 100.0
        
        HorizontalBarChartView.rightAxis.enabled = true
        HorizontalBarChartView.rightAxis.labelFont = UIFont.systemFont(ofSize: 10, weight: UIFontWeightLight)
        HorizontalBarChartView.rightAxis.drawAxisLineEnabled = true
        HorizontalBarChartView.rightAxis.drawGridLinesEnabled = false
        HorizontalBarChartView.rightAxis.axisMinimum = 0.0 // this replaces startAtZero = YES
        HorizontalBarChartView.rightAxis.axisMaximum = 100.0
        
        HorizontalBarChartView.fitBars = true
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
    

    internal func updateBarChartWithData(_ HorizontalBarChartView: HorizontalBarChartView, value: Int) {
        let dataEntries = [BarChartDataEntry(x: 1.0, yValues: [Double(value), Double(100-value)], label: "")]
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
        
        chartDataSet.colors = [Constants.darkColor, Constants.lightColor]
        chartDataSet.drawValuesEnabled = false
        
        let chartData = BarChartData(dataSet: chartDataSet)
        HorizontalBarChartView.data = chartData
    }
    
    @IBAction func onChangingGroupSelection(_ sender: Any) {
        switch groupSelectionSegment.selectedSegmentIndex {
        case 0:
            updateBarChartWithData(groupAccountingChart, value: jsonData["groupStatus"]["Month"].intValue)
        case 1:
            updateBarChartWithData(groupAccountingChart, value: jsonData["groupStatus"]["6Months"].intValue)
        case 2:
            updateBarChartWithData(groupAccountingChart, value: jsonData["groupStatus"]["Avg1Y"].intValue)
        default:
            print("wrong!")
        }
        
        groupAccountingChart.animate(yAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
    }

    @IBAction func onPublish(_ sender: Any) {
    }
    
    @IBAction func onDiagnostics(_ sender: Any) {
    }

    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("selected")
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        print("unselected")
    }
    

}
