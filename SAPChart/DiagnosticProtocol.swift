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
    func updateChart(diagnosticsView: DiagnosticView, animated: Bool,  json: JSON)
    func animateChart(diagnosticsView: DiagnosticView)
}

extension DiagnosticProtocol {
    func configCharts(diagnosticsView: DiagnosticView) {
        configTicketLineChart(diagnosticsView.ticketsLineChartView)
        configTicketLineChart(diagnosticsView.dataQualityChartView)
        configCompletitionLineChart(diagnosticsView.completitionLineChartView)
    }

    func updateChart(diagnosticsView: DiagnosticView, animated: Bool, json: JSON) {
        updateTicketLineChart(diagnosticsView.ticketsLineChartView, json: json["meTickets"], colorArray: Constants.meTicketsColorArray, labelArray: Constants.meTicketsLabelArray)
        updateTicketLineChart(diagnosticsView.dataQualityChartView, json: json["quatiltyTickets"], colorArray: Constants.qualityTicketsColorArray, labelArray: Constants.qualityTicketsLabelArray)
        updateCompletitionLineChart(diagnosticsView.completitionLineChartView, json: json["meCompletition"], colorArray: Constants.qualityCompletitionColorArray, labelArray: Constants.qualityCompletitionLabelArray)
        
        diagnosticsView.noResponseBoxView.topLabel.text = "No\nResponse"
        diagnosticsView.noResponseBoxView.centerLabel.text = "\(json["botResponses"]["noResponse"].intValue)%"
        diagnosticsView.lateResponseBoxView.topLabel.text = "Late\nResponse"
        diagnosticsView.lateResponseBoxView.centerLabel.text = "\(json["botResponses"]["lateResponse"].intValue)%"
        diagnosticsView.delayNextStepBoxView.topLabel.text = "Delay in\nNext Step"
        diagnosticsView.delayNextStepBoxView.centerLabel.text = "\(json["botResponses"]["delay"].intValue)%"
    }

    func animateChart(diagnosticsView: DiagnosticView) {
        diagnosticsView.ticketsLineChartView.animate(xAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
        diagnosticsView.dataQualityChartView.animate(xAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
        diagnosticsView.completitionLineChartView.animate(xAxisDuration: Constants.animationTime, easingOption: .easeOutBack)
    }

    internal func configTicketLineChart(_ lineChartView: LineChartView) {
        lineChartView.setViewPortOffsets(left: 40.0, top: 20.0, right: 20.0, bottom: 30.0)
        lineChartView.highlightPerTapEnabled = false
        
        lineChartView.chartDescription?.enabled = false
        lineChartView.chartDescription?.text = nil
        lineChartView.legend.enabled = true
        lineChartView.legend.form = .circle
        lineChartView.legend.formSize = 12.0
        lineChartView.legend.font = UIFont(name: "HelveticaNeue-Light", size: 12.0)!
        lineChartView.legend.position = .aboveChartRight
        
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.dragEnabled = false
        lineChartView.setScaleEnabled(false)
        lineChartView.pinchZoomEnabled = false
        
        lineChartView.leftAxis.enabled = false
        lineChartView.leftAxis.spaceTop = 0.4
        lineChartView.leftAxis.spaceBottom = 0.4
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.enabled = false
        
        lineChartView.xAxis.enabled = true
        lineChartView.xAxis.drawLabelsEnabled = true
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.granularity = 1.0
        lineChartView.xAxis.valueFormatter = DayFormatter()

        lineChartView.leftAxis.enabled = true
        lineChartView.leftAxis.drawLabelsEnabled = true
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = true
        lineChartView.leftAxis.axisMinimum = 0.0 // this replaces startAtZero = YES
        lineChartView.leftAxis.axisMaximum = 9.0
        lineChartView.leftAxis.granularity = 2.0
        lineChartView.leftAxis.valueFormatter = ValueFormatter()
    }
    
    
    internal func configCompletitionLineChart(_ lineChartView: LineChartView) {
        lineChartView.setViewPortOffsets(left: 40.0, top: 20.0, right: 20.0, bottom: 30.0)
        lineChartView.highlightPerTapEnabled = false
        
        lineChartView.chartDescription?.enabled = false
        lineChartView.chartDescription?.text = nil
        lineChartView.legend.enabled = true
        lineChartView.legend.form = .circle
        lineChartView.legend.formSize = 12.0
        lineChartView.legend.font = UIFont(name: "HelveticaNeue-Light", size: 12.0)!
        lineChartView.legend.position = .aboveChartRight
        
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.dragEnabled = false
        lineChartView.setScaleEnabled(false)
        lineChartView.pinchZoomEnabled = false
        
        lineChartView.leftAxis.enabled = false
        lineChartView.leftAxis.spaceTop = 0.4
        lineChartView.leftAxis.spaceBottom = 0.4
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.enabled = false
        lineChartView.xAxis.valueFormatter = DayFormatter()
        
        lineChartView.xAxis.enabled = true
        lineChartView.xAxis.drawLabelsEnabled = true
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.granularity = 1.0
        
        lineChartView.leftAxis.enabled = true
        lineChartView.leftAxis.drawLabelsEnabled = true
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.axisMinimum = 0.0 // this replaces startAtZero = YES
        lineChartView.leftAxis.axisMaximum = 11.0
        lineChartView.leftAxis.granularity = 5.0
        lineChartView.leftAxis.valueFormatter = ValueFormatter()
    }
    
    
    internal func updateTicketLineChart(_ lineChartView: LineChartView, json: JSON, colorArray: [UIColor], labelArray: [String]) {
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
        
        var dataSets: [LineChartDataSet] = []
        var dataSetIndex = 0
        
        for arrayEntry in json.array! {
            var dataEntries: [ChartDataEntry] = []
            
            var x = 0.0
            for data in arrayEntry.array! {
                dataEntries.append(ChartDataEntry(x: x, y: Double(data.intValue)))
                x += 1.0
            }
            
            let chartDataSet = LineChartDataSet(values: dataEntries, label:  labelArray[dataSetIndex % labelArray.count])
            setDataSet(chartDataSet, color: colorArray[dataSetIndex % colorArray.count])
            dataSets.append(chartDataSet)
            dataSetIndex += 1
        }
        
        let chartData = LineChartData(dataSets: dataSets)
        lineChartView.data = chartData
    }

    
    internal func updateCompletitionLineChart(_ lineChartView: LineChartView, json: JSON, colorArray: [UIColor],  labelArray: [String]) {
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
        
        
        var dataSets: [LineChartDataSet] = []
        var dataSetIndex = 0
        
        for arrayEntry in json.array! {
            var dataEntries: [ChartDataEntry] = []
            
            var x = 0.0
            for data in arrayEntry.array! {
                dataEntries.append(ChartDataEntry(x: x, y: Double(data.intValue)))
                x += 1.0
            }
            
            let chartDataSet = LineChartDataSet(values: dataEntries, label: labelArray[dataSetIndex % labelArray.count])
            setDataSet(chartDataSet, color: colorArray[dataSetIndex % colorArray.count])
            dataSets.append(chartDataSet)
            dataSetIndex += 1
        }
        
        let chartData = LineChartData(dataSets: dataSets)
        lineChartView.data = chartData
    }
}

open class DayFormatter: NSObject, IAxisValueFormatter {
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "\nDay \(Int(value) + 1)"
    }
}

open class ValueFormatter: NSObject, IAxisValueFormatter {
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "\(Int(value) )    "
    }
}
