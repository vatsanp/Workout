//
//  WeightViewController.swift
//  Workout
//
//  Created by Vatsan Prabhu on 2020-09-15.
//  Copyright © 2020 vatsan. All rights reserved.
//

import UIKit

class WeightViewController: UIViewController {
	
	@IBOutlet var weightField: UITextField!
	@IBOutlet var dateField: UITextField!
	
	var weightData: [Date:Double]!
	var weightValues: [Double] = Array(stride(from: 50.0, through: 300.0, by: 0.1))
	var weightString = ""
	var dateString = ""
	var selectedWeight: Double!
	var selectedDate: Date!
	var previousWeight: Double!
	
	var weightPicker = UIPickerView()
	let datePicker = UIDatePicker()
	
	let defaults = UserDefaults.standard
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if weightData != nil {
			let reversedDates = Array(Array(weightData.keys).sorted().reversed())
			previousWeight = weightData[reversedDates[0]]
			weightField.placeholder = String(previousWeight)
		}
		else { weightData = [:] }
		
		let formatter = DateFormatter()
		formatter.dateFormat = "MMMM dd, yyyy"
		dateField.text = formatter.string(from: Date())
		
		
		weightField.delegate = self
		dateField.delegate = self
		
		weightPicker.dataSource = self
		weightPicker.delegate = self
		
		let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	//Display picker views for textfields
	func displayPicker(for textField: UITextField) {
		let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
		
		let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
		let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelPressed))
		
		toolbar.setItems([cancelBtn, flexSpace, doneBtn], animated: true)
		
		textField.inputAccessoryView = toolbar
		if textField == weightField {
			textField.inputView = weightPicker
			if previousWeight != nil {
				let selection = weightValues.firstIndex(of: previousWeight) ?? 0
				weightPicker.selectRow(selection, inComponent: 0, animated: true)
				pickerView(weightPicker, didSelectRow: selection, inComponent: 0)
			}
		}
		else {
			datePicker.datePickerMode = .date
			textField.inputView = datePicker
			datePicker.setDate(Date(), animated: true)
		}
		
	}
	
	@objc func donePressed() {
		let formatter = DateFormatter()
		formatter.dateStyle = .long
		formatter.timeStyle = .none
		
		weightField.text = weightString
		dateField.text = formatter.string(from: datePicker.date.removeTimeStamp())
		selectedDate = datePicker.date.removeTimeStamp()
		self.view.endEditing(true)
	}
	
	@objc func cancelPressed() { self.view.endEditing(true) }
	
	//Save weight entry
	@IBAction func saveWeight(_ sender: Any) {
		if !(weightField.text?.isEmpty ?? true) {
			let formatter = DateFormatter()
			formatter.dateFormat = "MM/dd/yyyy"
			formatter.timeStyle = .none
			let date = selectedDate!

			if weightData != nil && weightData[date] == nil {
				weightData[date] = selectedWeight!
				
				if let encodedData = try? PropertyListEncoder().encode(weightData) {
					self.defaults.set(encodedData, forKey: "weightData")
				}
				else { print("Unable to store events") }
				performSegue(withIdentifier: "unwind", sender: self)
			}
			else {
				//Provide alert to ask if user wants to override weight
				let alert = UIAlertController(title: "Replace existing weight for this date?", message: nil, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Replace", style: .destructive, handler: { (Void) in
					self.weightData[date] = self.selectedWeight
					
					if let encodedData = try? PropertyListEncoder().encode(self.weightData) {
						self.defaults.set(encodedData, forKey: "weightData")
					}
					else { print("Unable to store events") }
					self.performSegue(withIdentifier: "unwind", sender: self)
				}))
				alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
				self.present(alert, animated: true, completion: nil)
			}
		}
	}
	
	@IBAction func cancelWeight(_ sender: Any) {
		performSegue(withIdentifier: "unwind", sender: self)
	}
}

extension WeightViewController: UITextFieldDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		displayPicker(for: textField)
	}
}

extension WeightViewController: UIPickerViewDelegate, UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return weightValues.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return String(weightValues[row])
    }
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		selectedWeight = Double(weightValues[pickerView.selectedRow(inComponent: 0)])
		weightString = "\(selectedWeight!) lbs"
	}
}

extension Date {
	public func removeTimeStamp() -> Date {
		guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
			fatalError("Failed to strip time from Date object")
		}
		return date
	}
}
