//
//  MeasurementsViewController.swift
//  Workout
//
//  Created by Vatsan Prabhu on 2020-09-04.
//  Copyright © 2020 vatsan. All rights reserved.
//

import UIKit

class MeasurementsViewController: UIViewController {
	
	@IBOutlet var heightField: UITextField!
	@IBOutlet var weightField: UITextField!
	@IBOutlet var weightTable: UITableView!
	
	var heightPicker = UIPickerView()
	var weightPicker = UIPickerView()
	
	var heightValues: [Int] = Array(3...8)
	var weightValues: [Double] = Array(stride(from: 50.0, through: 300.0, by: 0.1))
	var heightString = ""
	var weightString = ""
	var weightData: [Date:Double]!
	var reversedDates: [Date]!
	
	let defaults = UserDefaults.standard
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "Body Measurements"
		
		//Get weight data
		let weights = defaults.object(forKey: "weightData")
		if weights != nil {
			if let decodedData = try? PropertyListDecoder().decode([Date:Double].self, from: weights as! Data) {
				weightData = decodedData
				reversedDates = Array(Array(weightData.keys).sorted().reversed())
			}
			else { print("Unable to retrieve events") }
		}
		
		heightField.delegate = self
		heightField.inputView = UIView()
		heightField.inputAccessoryView = UIView()
		heightField.tintColor = .clear
		weightField.delegate = self
		weightField.inputView = UIView()
		weightField.inputAccessoryView = UIView()
		weightField.tintColor = .clear
		
		heightPicker.dataSource = self
		heightPicker.delegate = self
		weightPicker.dataSource = self
		weightPicker.delegate = self
		
		weightTable.dataSource = self
		weightTable.delegate = self
		
		let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	//Display picker view for textfields
	func displayPicker(for textField: UITextField) {
		let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
		
		let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
		let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelPressed))
		
		toolbar.setItems([cancelBtn, flexSpace, doneBtn], animated: true)
		
		textField.inputAccessoryView = toolbar
		if textField == heightField {
			textField.inputView = heightPicker
			heightPicker.selectRow(2, inComponent: 0, animated: true)
			pickerView(heightPicker, didSelectRow: 2, inComponent: 0)
		}
		else {
			textField.inputView = weightPicker
			weightPicker.selectRow(70, inComponent: 0, animated: true)
			pickerView(weightPicker, didSelectRow: 70, inComponent: 0)
		}
		
	}
	
	@objc func donePressed() {
		heightField.text = heightString
		weightField.text = weightString
		self.view.endEditing(true)
	}
	
	@objc func cancelPressed() { self.view.endEditing(true) }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is WeightViewController
		{
			let vc = segue.destination as? WeightViewController
			vc?.weightData = weightData
		}
	}
	
	@IBAction func unwind(segue: UIStoryboardSegue) {
		if let decodedData = try? PropertyListDecoder().decode([Date:Double].self, from: defaults.object(forKey: "weightData") as! Data) {
			weightData = decodedData
			reversedDates = Array(Array(weightData.keys).sorted().reversed())
		}
		else { print("Unable to retrieve events") }
		
		weightTable.reloadData()
	}
}

extension MeasurementsViewController: UITextFieldDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		displayPicker(for: textField)
	}
}

extension MeasurementsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		if pickerView == heightPicker { return 2 }
		else { return 1 }
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if pickerView == heightPicker {
			if component == 0 { return heightValues.count }
			else { return 12 }
			
		}
		else { return weightValues.count }
    }
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if pickerView == heightPicker {
			if component == 0 { return String(heightValues[row]) }
			else { return String(row) }
		}
		else { return String(weightValues[row]) }
    }
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if pickerView == heightPicker { heightString = "\(heightValues[pickerView.selectedRow(inComponent: 0)]) ft \(pickerView.selectedRow(inComponent: 1)) in" }
		else { weightString = "\(weightValues[pickerView.selectedRow(inComponent: 0)]) lbs" }
	}
}

extension MeasurementsViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if weightData != nil { return weightData.count }
		else { return 0 }
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = weightTable.dequeueReusableCell(withIdentifier: "weightCell", for: indexPath) as! WeightCell
		let formatter = DateFormatter()
		formatter.dateFormat = "MMMM dd, yyyy"
		
		cell.dateLabel.text = formatter.string(from: reversedDates[indexPath.row])
		cell.weightLabel.text = "\(weightData[reversedDates[indexPath.row]] ?? 0) lbs"
		
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
			
			let cell = tableView.cellForRow(at: indexPath) as! WeightCell
			let formatter = DateFormatter()
			formatter.dateFormat = "MMMM dd, yyyy"
			let date = formatter.date(from: cell.dateLabel.text!)!

            weightData[date] = nil

            tableView.deleteRows(at: [indexPath], with: .fade)
			
			if let encodedData = try? PropertyListEncoder().encode(weightData) {
				self.defaults.set(encodedData, forKey: "weightData")
			}
			else { print("Unable to store events") }
        }
    }
}
