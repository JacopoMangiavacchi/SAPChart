//
//  MonthEndViewController.swift
//  SAPChart
//
//  Created by Jacopo Mangiavacchi on 4/10/17.
//  Copyright © 2017 Jacopo. All rights reserved.
//

import UIKit
import Charts

class MonthEndViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var ppChart: PieChartView!
    @IBOutlet weak var fpChart: PieChartView!
    @IBOutlet weak var cpChart: PieChartView!
    @IBOutlet weak var ufpChart: PieChartView!
    @IBOutlet weak var saChart: PieChartView!
    
    @IBOutlet weak var groupAccountingChart: HorizontalBarChartView!
    
    @IBOutlet weak var publishButton: UIButton!
    
    @IBOutlet weak var groupSelectionSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configPieChart(ppChart, label: "PP")
        configPieChart(fpChart, label: "FP")
        configPieChart(cpChart, label: "CP")
        configPieChart(ufpChart, label: "UFP")
        configPieChart(saChart, label: "SA")

        configBarChart(groupAccountingChart)
        
        updatePieChartWithData(ppChart, value: Data.plantStatus["PP"]!, label: "PP")
        updatePieChartWithData(fpChart, value: Data.plantStatus["FP"]!, label: "FP")
        updatePieChartWithData(cpChart, value: Data.plantStatus["CP"]!, label: "CP")
        updatePieChartWithData(ufpChart, value: Data.plantStatus["UFP"]!, label: "UFP")
        updatePieChartWithData(saChart, value: Data.plantStatus["SA"]!, label: "SA")

        updateBarChartWithData(groupAccountingChart, value: Data.groupStatus["Month"]!)
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
        pieChartView.entryLabelFont = UIFont(name: "HelveticaNeue-Light", size: 16.0)

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
        pieChartView.centerText = label
    
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
            updateBarChartWithData(groupAccountingChart, value: Data.groupStatus["Month"]!)
        case 1:
            updateBarChartWithData(groupAccountingChart, value: Data.groupStatus["6Months"]!)
        case 2:
            updateBarChartWithData(groupAccountingChart, value: Data.groupStatus["Avg1Y"]!)
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
