//
//  ViewController.swift
//  SAPChart
//
//  Created by Jacopo Mangiavacchi on 4/10/17.
//  Copyright © 2017 Jacopo. All rights reserved.
//

import UIKit
import Charts

let darkColor = UIColor(red: 210/255.0, green: 110/255.0, blue: 43/255.0, alpha: 1.0)
let lightColor = UIColor(red: 241/255.0, green: 167/255.0, blue: 138/255.0, alpha: 1.0)

let barColor1 = UIColor(red: 186/255.0, green: 97/255.0, blue: 37/255.0, alpha: 1.0)
let barColor2 = UIColor(red: 222/255.0, green: 117/255.0, blue: 45/255.0, alpha: 1.0)
let barColor3 = UIColor(red: 240/255.0, green: 153/255.0, blue: 113/255.0, alpha: 1.0)
let barColor4 = UIColor(red: 245/255.0, green: 194/255.0, blue: 176/255.0, alpha: 1.0)

let animationTime = 1.5

class ViewController: UIViewController {

    @IBOutlet weak var ppChart: PieChartView!
    @IBOutlet weak var fpChart: PieChartView!
    @IBOutlet weak var cpChart: PieChartView!
    @IBOutlet weak var ufpChart: PieChartView!
    @IBOutlet weak var saChart: PieChartView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configPieChart(ppChart)
        configPieChart(fpChart)
        configPieChart(cpChart)
        configPieChart(ufpChart)
        configPieChart(saChart)
        
        
        updateChartWithData(ppChart, value: 80, label: "PP")
        updateChartWithData(fpChart, value: 15, label: "FP")
        updateChartWithData(cpChart, value: 45, label: "CP")
        updateChartWithData(ufpChart, value: 87, label: "UFP")
        updateChartWithData(saChart, value: 80, label: "SA")
    }

    override func viewDidAppear(_ animated: Bool) {
        ppChart.animate(xAxisDuration: animationTime, easingOption: .easeOutBack)
        fpChart.animate(xAxisDuration: animationTime, easingOption: .easeOutBack)
        cpChart.animate(xAxisDuration: animationTime, easingOption: .easeOutBack)
        ufpChart.animate(xAxisDuration: animationTime, easingOption: .easeOutBack)
        saChart.animate(xAxisDuration: animationTime, easingOption: .easeOutBack)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    internal func configPieChart(_ pieChartView: PieChartView) {
        pieChartView.entryLabelColor = UIColor.white
        pieChartView.entryLabelFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)

        let legend = pieChartView.legend
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.xEntrySpace = 7.0
        legend.yEntrySpace = 0.0
        legend.yOffset = 0.0
    }

    
    internal func updateChartWithData(_ pieChartView: PieChartView, value: Int, label: String) {
        let dataEntries = [PieChartDataEntry(value: Double(value), label: "\(value)%"), PieChartDataEntry(value: Double(100-value), label: "\(100-value)%")]
        let chartDataSet = PieChartDataSet(values: dataEntries, label: label)
        
        //chartDataSet.drawIconsEnabled = false
        //chartDataSet.iconsOffset = CGPointMake(0, 40);
        
        chartDataSet.sliceSpace = 2.0
        
        chartDataSet.colors = [darkColor, lightColor]
        
        
        let chartData = PieChartData(dataSet: chartDataSet)
        pieChartView.data = chartData
    }
}


//- (void)setupppChartView:(ppChartView *)chartView
//{
//    chartView.usePercentValuesEnabled = YES;
//    chartView.drawSlicesUnderHoleEnabled = NO;
//    chartView.holeRadiusPercent = 0.58;
//    chartView.transparentCircleRadiusPercent = 0.61;
//    chartView.chartDescription.enabled = NO;
//    [chartView setExtraOffsetsWithLeft:5.f top:10.f right:5.f bottom:5.f];
//    
//    chartView.drawCenterTextEnabled = YES;
//    
//    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
//    paragraphStyle.alignment = NSTextAlignmentCenter;
//    
//    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"Charts\nby Daniel Cohen Gindi"];
//    [centerText setAttributes:@{
//        NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:13.f],
//        NSParagraphStyleAttributeName: paragraphStyle
//        } range:NSMakeRange(0, centerText.length)];
//    [centerText addAttributes:@{
//        NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f],
//        NSForegroundColorAttributeName: UIColor.grayColor
//        } range:NSMakeRange(10, centerText.length - 10)];
//    [centerText addAttributes:@{
//        NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:11.f],
//        NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]
//        } range:NSMakeRange(centerText.length - 19, 19)];
//    chartView.centerAttributedText = centerText;
//    
//    chartView.drawHoleEnabled = YES;
//    chartView.rotationAngle = 0.0;
//    chartView.rotationEnabled = YES;
//    chartView.highlightPerTapEnabled = YES;
//    
//    ChartLegend *l = chartView.legend;
//    l.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
//    l.verticalAlignment = ChartLegendVerticalAlignmentTop;
//    l.orientation = ChartLegendOrientationVertical;
//    l.drawInside = NO;
//    l.xEntrySpace = 7.0;
//    l.yEntrySpace = 0.0;
//    l.yOffset = 0.0;
//}
//
