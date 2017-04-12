//
//  ViewController.swift
//  SAPChart
//
//  Created by Jacopo Mangiavacchi on 4/10/17.
//  Copyright © 2017 Jacopo. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {

    @IBOutlet weak var ppChart: PieChartView!
    @IBOutlet weak var fpChart: PieChartView!
    @IBOutlet weak var cpChart: PieChartView!
    @IBOutlet weak var ufpChart: PieChartView!
    @IBOutlet weak var saChart: PieChartView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configPieChart(ppChart, label: "PP")
        configPieChart(fpChart, label: "FP")
        configPieChart(cpChart, label: "CP")
        configPieChart(ufpChart, label: "UFP")
        configPieChart(saChart, label: "SA")
        
        updateChartWithData(ppChart, value: Data.plantStatus["PP"]!, label: "PP")
        updateChartWithData(fpChart, value: Data.plantStatus["FP"]!, label: "FP")
        updateChartWithData(cpChart, value: Data.plantStatus["CP"]!, label: "CP")
        updateChartWithData(ufpChart, value: Data.plantStatus["UFP"]!, label: "UFP")
        updateChartWithData(saChart, value: Data.plantStatus["SA"]!, label: "SA")
    }

    override func viewDidAppear(_ animated: Bool) {
        ppChart.animate(xAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
        fpChart.animate(xAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
        cpChart.animate(xAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
        ufpChart.animate(xAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
        saChart.animate(xAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    internal func configPieChart(_ pieChartView: PieChartView, label: String) {
        pieChartView.entryLabelColor = UIColor.white
        pieChartView.entryLabelFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)

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

    
    internal func updateChartWithData(_ pieChartView: PieChartView, value: Int, label: String) {
        let dataEntries = [PieChartDataEntry(value: Double(value), label: "\(value)%"), PieChartDataEntry(value: Double(100-value), label: "\(100-value)%")]
        let chartDataSet = PieChartDataSet(values: dataEntries, label: label)
        
        //chartDataSet.drawIconsEnabled = false
        //chartDataSet.iconsOffset = CGPointMake(0, 40);
        
        chartDataSet.sliceSpace = 2.0
        chartDataSet.colors = [Constants.darkColor, Constants.lightColor]
        chartDataSet.drawValuesEnabled = false
        
        
        let chartData = PieChartData(dataSet: chartDataSet)
        pieChartView.data = chartData
    }
}
