//
//  DiagnosticProtocol.swift
//  SAPChart
//
//  Created by Jacopo Mangiavacchi on 4/24/17.
//  Copyright © 2017 Jacopo. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON

protocol DiagnosticProtocol {
    func configCharts(diagnosticsView: DiagnosticView)
    func updateChart(diagnosticsView: DiagnosticView, animated: Bool)
}
    
extension DiagnosticProtocol {
    func configCharts(diagnosticsView: DiagnosticView) {
        configTicketLineChart(diagnosticsView.ticketsLineChartView)
        configTicketLineChart(diagnosticsView.dataQualityChartView)
        configCompletitionLineChart(diagnosticsView.completitionLineChartView)
    }
    
    func updateChart(diagnosticsView: DiagnosticView, animated: Bool) {
        updateTicketLineChart(diagnosticsView.ticketsLineChartView)
        updateTicketLineChart(diagnosticsView.dataQualityChartView)
        updateCompletitionLineChart(diagnosticsView.completitionLineChartView)
    }

    
    internal func configTicketLineChart(_ lineChartView: LineChartView) {
        lineChartView.highlightPerTapEnabled = false
        
        lineChartView.chartDescription?.enabled = false
        lineChartView.chartDescription?.text = nil
        lineChartView.legend.enabled = false
        lineChartView.legend.setCustom(entries: [])
        
        
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.dragEnabled = false
        lineChartView.setScaleEnabled(true)
        lineChartView.pinchZoomEnabled = false
        
        //lineChartView.setViewPortOffsets(left: 10.0, top: 0.0, right: 10.0, bottom: 0.0)
        
        lineChartView.leftAxis.enabled = false
        lineChartView.leftAxis.spaceTop = 0.4
        lineChartView.leftAxis.spaceBottom = 0.4
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.enabled = false
    }
    
    
    internal func configCompletitionLineChart(_ lineChartView: LineChartView) {
        lineChartView.highlightPerTapEnabled = false
        
        lineChartView.chartDescription?.enabled = false
        lineChartView.chartDescription?.text = nil
        lineChartView.legend.enabled = false
        lineChartView.legend.setCustom(entries: [])
        
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.dragEnabled = false
        lineChartView.setScaleEnabled(true)
        lineChartView.pinchZoomEnabled = false
        
        //lineChartView.setViewPortOffsets(left: 10.0, top: 0.0, right: 10.0, bottom: 0.0)
        
        lineChartView.leftAxis.enabled = false
        lineChartView.leftAxis.spaceTop = 0.4
        lineChartView.leftAxis.spaceBottom = 0.4
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.enabled = false
    }
    
    
    internal func updateTicketLineChart(_ lineChartView: LineChartView) {
        func setDataSet(_ chartDataSet: LineChartDataSet, color: UIColor) {
            chartDataSet.lineWidth = 1.75
            chartDataSet.circleRadius = 6.0
            chartDataSet.circleHoleRadius = 8
            chartDataSet.setColor(color)
            chartDataSet.setCircleColor(color)
            chartDataSet.circleHoleColor = color
            
            //chartDataSet.colors = [Constants.darkColor, Constants.lightColor]
            chartDataSet.drawValuesEnabled = false
        }
        
        let dataEntries1 = [ChartDataEntry(x: 0.0, y: 3.0), ChartDataEntry(x: 1.0, y: 1.0), ChartDataEntry(x: 2.0, y: 7.0), ChartDataEntry(x: 3.0, y: 3.0), ChartDataEntry(x: 4.0, y: 1.0), ChartDataEntry(x: 5.0, y: 7.0)]
        let dataEntries2 = [ChartDataEntry(x: 0.0, y: 5.0), ChartDataEntry(x: 1.0, y: 13.0), ChartDataEntry(x: 2.0, y: 5.0), ChartDataEntry(x: 3.0, y: 10.0), ChartDataEntry(x: 4.0, y: 7.0), ChartDataEntry(x: 5.0, y: 11.0)]
        
        
        let chartDataSet1 = LineChartDataSet(values: dataEntries1, label: "")
        let chartDataSet2 = LineChartDataSet(values: dataEntries2, label: "")
        
        setDataSet(chartDataSet1, color:Constants.darkColor)
        setDataSet(chartDataSet2, color:Constants.lightColor)
        
        let chartData = LineChartData(dataSets: [chartDataSet1, chartDataSet2])
        lineChartView.data = chartData
    }

    
    internal func updateCompletitionLineChart(_ lineChartView: LineChartView) {
        func setDataSet(_ chartDataSet: LineChartDataSet, color: UIColor) {
            chartDataSet.lineWidth = 1.75
            chartDataSet.drawCirclesEnabled = false
            chartDataSet.setColor(color)
            
            chartDataSet.fillAlpha = 0.26
            chartDataSet.fillColor = Constants.darkColor
            chartDataSet.drawFilledEnabled = true
            
            //chartDataSet.colors = [Constants.darkColor, Constants.lightColor]
            chartDataSet.drawValuesEnabled = false
        }
        
        let dataEntries1 = [ChartDataEntry(x: 0.0, y: 10.0), ChartDataEntry(x: 1.0, y: 26.0), ChartDataEntry(x: 2.0, y: 10.0), ChartDataEntry(x: 3.0, y: 20.0), ChartDataEntry(x: 4.0, y: 14.0), ChartDataEntry(x: 5.0, y: 22.0)]
        let dataEntries2 = [ChartDataEntry(x: 0.0, y: 5.0), ChartDataEntry(x: 1.0, y: 13.0), ChartDataEntry(x: 2.0, y: 5.0), ChartDataEntry(x: 3.0, y: 10.0), ChartDataEntry(x: 4.0, y: 7.0), ChartDataEntry(x: 5.0, y: 11.0)]
        
        
        let chartDataSet1 = LineChartDataSet(values: dataEntries1, label: "")
        let chartDataSet2 = LineChartDataSet(values: dataEntries2, label: "")
        
        setDataSet(chartDataSet1, color:Constants.darkColor)
        setDataSet(chartDataSet2, color:Constants.lightColor)
        
        let chartData = LineChartData(dataSets: [chartDataSet1, chartDataSet2])
        lineChartView.data = chartData
    }
}
