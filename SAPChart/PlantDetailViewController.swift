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


class PlantDetailViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var ppChart: PieChartView!
    @IBOutlet weak var fpChart: PieChartView!
    @IBOutlet weak var cpChart: PieChartView!
    @IBOutlet weak var ufpChart: PieChartView!
    @IBOutlet weak var saChart: PieChartView!
    
    @IBOutlet weak var groupAccountingChart: HorizontalBarChartView!
    
    var jsonData: JSON!
    var plant: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configPieChart(ppChart, label: plant)
        
        configBarChart(groupAccountingChart)
        
        updatePieChartWithData(ppChart, value: jsonData["plantStatus"][plant].intValue, label: plant)
        
        updateBarChartWithData(groupAccountingChart, value: jsonData["groupStatus"]["Month"].intValue)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ppChart.animate(xAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
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
    
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("selected")
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        print("unselected")
    }
    
    
}
