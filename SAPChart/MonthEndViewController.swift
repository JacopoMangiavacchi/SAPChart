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
    
    @IBOutlet weak var groupSelectionSegment: UISegmentedControl!
    
    var jsonData: JSON!
    var selectedPlant: String?
    
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
    }

    override func viewDidAppear(_ animated: Bool) {
        ppChart.clear()
        fpChart.clear()
        cpChart.clear()
        ufpChart.clear()
        saChart.clear()
        groupAccountingChart.clear()
        
        updatePieChartWithData(ppChart, value: jsonData["plantStatus"]["PP"]["completition"].intValue, label: "PP")
        updatePieChartWithData(fpChart, value: jsonData["plantStatus"]["FP"]["completition"].intValue, label: "FP")
        updatePieChartWithData(cpChart, value: jsonData["plantStatus"]["CP"]["completition"].intValue, label: "CP")
        updatePieChartWithData(ufpChart, value: jsonData["plantStatus"]["UFP"]["completition"].intValue, label: "UFP")
        updatePieChartWithData(saChart, value: jsonData["plantStatus"]["SA"]["completition"].intValue, label: "SA")
        
        updateBarChart(groupAccountingChart)

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
        
        horizontalBarChartView.highlightPerTapEnabled = false
        
        horizontalBarChartView.chartDescription?.text = nil
        horizontalBarChartView.legend.setCustom(entries: [])
        
        
        horizontalBarChartView.drawGridBackgroundEnabled = false
        horizontalBarChartView.dragEnabled = false
        horizontalBarChartView.setScaleEnabled(false)
        horizontalBarChartView.pinchZoomEnabled = false
        horizontalBarChartView.xAxis.labelPosition = .top
        horizontalBarChartView.xAxis.labelTextColor  = UIColor.white
        horizontalBarChartView.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 16.0)!
        horizontalBarChartView.xAxis.drawAxisLineEnabled = true
        horizontalBarChartView.xAxis.drawGridLinesEnabled = false
        horizontalBarChartView.xAxis.granularity = 10.0

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
        
        let currentMonth = jsonData["groupStatus"]["Month"].intValue
        let sixMonth = jsonData["groupStatus"]["6Months"].intValue
        let averageYear = jsonData["groupStatus"]["Avg1Y"].intValue
        
        let dataEntries = [BarChartDataEntry(x: 3.0, yValues: [Double(currentMonth), Double(100-currentMonth)]),
                           BarChartDataEntry(x: 2.0, yValues: [Double(sixMonth), Double(100-sixMonth)]),
                           BarChartDataEntry(x: 1.0, yValues: [Double(averageYear), Double(100-averageYear)])]
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
        
        chartDataSet.colors = [Constants.darkColor, Constants.lightColor]
        chartDataSet.drawValuesEnabled = false
        
        let chartData = BarChartData(dataSet: chartDataSet)
        horizontalBarChartView.data = chartData
    }
    
    @IBAction func onChangingGroupSelection(_ sender: Any) {
//        switch groupSelectionSegment.selectedSegmentIndex {
//        case 0:
//            updateBarChartWithData(groupAccountingChart, value: jsonData["groupStatus"]["Month"].intValue)
//        case 1:
//            updateBarChartWithData(groupAccountingChart, value: jsonData["groupStatus"]["6Months"].intValue)
//        case 2:
//            updateBarChartWithData(groupAccountingChart, value: jsonData["groupStatus"]["Avg1Y"].intValue)
//        default:
//            print("wrong!")
//        }
//        
//        groupAccountingChart.animate(yAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
    }

    @IBAction func onPublish(_ sender: Any) {
        print("Publish")
    }
    
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        switch chartView {
        case ppChart:
            selectedPlant = "PP"
        case fpChart:
            selectedPlant = "FP"
        case cpChart:
            selectedPlant = "CP"
        case ufpChart:
            selectedPlant = "UFP"
        case saChart:
            selectedPlant = "SA"
        default:
            selectedPlant = nil
        }
        
        performSegue(withIdentifier: "showPlantDetails", sender: nil)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlantDetails" {
            let vc: PlantDetailViewController = segue.destination as! PlantDetailViewController
            vc.jsonData = jsonData
            vc.plant = selectedPlant!
        }
    }
}
