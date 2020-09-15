//
//  ActivityViewController.swift
//  Workout
//
//  Created by Vatsan Prabhu on 2020-09-13.
//  Copyright © 2020 vatsan. All rights reserved.
//

import UIKit
import Charts

class ActivityViewController: UIViewController {
	
	@IBOutlet var chartView: LineChartView!
	@IBOutlet var pieView: PieChartView!
	
	var weightData: [Date:Double]!
	var weightEntries: [ChartDataEntry]!
	var myEvents: [Date:[Event]]!
	var eventCount: Int!
	
	let defaults = UserDefaults.standard
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		myEvents = [:]
		weightData = [:]
		
		//Get events
		let events = defaults.object(forKey: "myEvents")
		if events != nil {
			if let decodedData = try? PropertyListDecoder().decode([Date:[Event]].self, from: events as! Data) {
				myEvents = decodedData
			}
			else { print("Unable to retrieve events") }
		}
		
		eventCount = Array(myEvents.values).reduce([], +).count
		
		weightEntries = getWeights()
		
		setWeightChartData()
		setEventPieData()
	}
	
	//Get weight data
	func getWeights() -> [ChartDataEntry] {
		var entries: [ChartDataEntry] = []
		
		let weights = defaults.object(forKey: "weightData")
		if weights != nil {
			if let decodedData = try? PropertyListDecoder().decode([Date:Double].self, from:  weights as! Data) {
				weightData = decodedData
			}
			else { print("Unable to retrieve events") }
		}
		
		let dates = Array(weightData.keys)
		let sortedDates = dates.sorted()
		
		for date in sortedDates {
			let dateDouble = Double(date.timeIntervalSince1970)
			entries.append(ChartDataEntry(x: dateDouble, y: weightData[date] ?? 100))
		}
		
		return entries
	}
	
	//Display weight data in a line chart
	func setWeightChartData() {
		chartView.rightAxis.enabled = false
		chartView.leftAxis.labelFont = .boldSystemFont(ofSize: 12)
		chartView.leftAxis.setLabelCount(5, force: false)
		chartView.leftAxis.axisLineColor = .clear
		chartView.xAxis.labelPosition = .bottom
		chartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
		chartView.xAxis.setLabelCount(7, force: true)
		chartView.xAxis.drawGridLinesEnabled = false
		chartView.xAxis.valueFormatter = self
		chartView.xAxis.axisLineColor = .clear
		chartView.legend.enabled = false
		chartView.minOffset = 50
		chartView.extraLeftOffset = 25
		chartView.extraTopOffset = 25
		chartView.animate(xAxisDuration: 2)
		chartView.isUserInteractionEnabled = false
		chartView.backgroundColor = .white
		
		let weightSet = LineChartDataSet(entries: weightEntries, label: "Weight")
		weightSet.drawCirclesEnabled = false
		weightSet.colors = [UIColor(red: 255/255.0, green: 75/255.0, blue: 0/255.0, alpha: 1)]
		weightSet.lineWidth = 2
		
		let data = LineChartData(dataSet: weightSet)
		data.setDrawValues(false)
		
		chartView.data = data
	}
	
	//Display event type activity in a pie chart
	func setEventPieData() {
		let paragraph = NSMutableParagraphStyle()
		paragraph.alignment = .center
		
		pieView.chartDescription?.enabled = false
		pieView.drawHoleEnabled = true
		pieView.rotationAngle = 0
		pieView.rotationEnabled = false
		pieView.isUserInteractionEnabled = false
		pieView.legend.enabled = false
		pieView.holeRadiusPercent = 0.75
		pieView.minOffset = 75
		pieView.centerAttributedText = NSAttributedString(string: "\(eventCount!) Total Workouts", attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .paragraphStyle: paragraph])
		pieView.centerTextRadiusPercent = 0.75
		pieView.animate(yAxisDuration: 2)
		pieView.backgroundColor = .white
		
		
		let events = Array(myEvents.values).reduce([], +)
		let gymCount = Double(events.filter({ $0.eventType == "Gym" }).count)
		let poolCount = Double(events.filter({ $0.eventType == "Pool" }).count)
		let classesCount = Double(events.filter({ $0.eventType == "Classes" }).count)
		
		var entries: [PieChartDataEntry] = []
		entries.append(PieChartDataEntry(value: gymCount/Double(eventCount) * 100, label: "Gym"))
		entries.append(PieChartDataEntry(value: poolCount/Double(eventCount) * 100, label: "Pool"))
		entries.append(PieChartDataEntry(value: classesCount/Double(eventCount) * 100, label: "Classes"))
		
		let dataSet = PieChartDataSet(entries: entries, label: "Event Types")
		dataSet.sliceSpace = 5
		dataSet.valueLineWidth = 0
		dataSet.valueLinePart1Length = 0.3
		dataSet.valueLinePart2Length = 0
		dataSet.valueTextColor = .black
		dataSet.valueFont = .boldSystemFont(ofSize: 12)
		dataSet.entryLabelColor = .black
		dataSet.entryLabelFont = .boldSystemFont(ofSize: 12)
		dataSet.yValuePosition = .outsideSlice
		dataSet.xValuePosition = .outsideSlice
		dataSet.valueLineVariableLength = false
		dataSet.colors = [
			UIColor(red: 255/255.0, green: 75/255.0, blue: 0/255.0, alpha: 1),
			UIColor(red: 255/255.0, green: 110/255.0, blue: 50/255.0, alpha: 1),
			UIColor(red: 255/255.0, green: 145/255.0, blue: 100/255.0, alpha: 1)
		]
		
		let formatter = NumberFormatter()
		formatter.numberStyle = .percent
		formatter.maximumFractionDigits = 1
		formatter.multiplier = 1
		
		let data = PieChartData(dataSet: dataSet)
		data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
		pieView.data = data
		
		

	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is WeightViewController
		{
			let vc = segue.destination as? WeightViewController
			vc?.weightData = weightData
		}
	}
}

extension ActivityViewController: IAxisValueFormatter {
	func stringForValue(_ value: Double, axis: AxisBase?) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "MM/dd"
		
		let date = Date(timeIntervalSince1970: value)
		let dateStr = formatter.string(from: date)
		
		return dateStr
	}
}
