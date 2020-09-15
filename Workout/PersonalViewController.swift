//
//  PersonalViewController.swift
//  Workout
//
//  Created by Vatsan Prabhu on 2020-08-31.
//  Copyright © 2020 vatsan. All rights reserved.
//

import UIKit

class PersonalViewController: UIViewController {
	
	@IBOutlet var cancelButton: UIBarButtonItem!
	@IBOutlet var saveButton: UIBarButtonItem!
	
	@IBOutlet var firstNameView: TextFieldView!
	@IBOutlet var lastNameView: TextFieldView!
	@IBOutlet var emailView: TextFieldView!
	@IBOutlet var phoneNumberView: TextFieldView!
	@IBOutlet var birthdayView: TextFieldView!
	@IBOutlet var genderView: TextFieldView!
	
	let datePicker = UIDatePicker()
	
	let defaults = UserDefaults.standard

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "Personal Details"
		
		initTextFields()
		
		saveButton.isEnabled = false
		saveButton.tintColor = .clear
		
		let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
		
	}
	
	func initTextFields() {
		firstNameView.textField.delegate = self
		lastNameView.textField.delegate = self
		emailView.textField.delegate = self
		phoneNumberView.textField.delegate = self
		birthdayView.textField.delegate = self
		genderView.textField.delegate = self
		
		birthdayView.textField.inputView = UIView()
		birthdayView.textField.inputAccessoryView = UIView()
		birthdayView.textField.tintColor = .clear
		genderView.textField.inputView = UIView()
		genderView.textField.inputAccessoryView = UIView()
		genderView.textField.tintColor = .clear
		
		firstNameView.textField.text = defaults.string(forKey: "firstName")
		lastNameView.textField.text = defaults.string(forKey: "lastName")
		emailView.textField.text = defaults.string(forKey: "email")
		phoneNumberView.textField.text = defaults.string(forKey: "phone")
		birthdayView.textField.text = defaults.string(forKey: "birthday")
		genderView.textField.text = defaults.string(forKey: "gender")
		
		for view in self.view.subviews as [UIView] {
			if let textView = view as? TextFieldView {
				if textView.textField.text?.isEmpty == false {
					textView.labelCenter.isActive = false
					textView.labelBottom.isActive = true
					textView.textFieldLabel.font = UIFont.systemFont(ofSize: 10)
				}
			}
		}
		
		firstNameView.layer.cornerRadius = 10
		firstNameView.layer.masksToBounds = true
		firstNameView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		lastNameView.layer.cornerRadius = 10
		lastNameView.layer.masksToBounds = true
		lastNameView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
		emailView.layer.cornerRadius = 10
		emailView.layer.masksToBounds = true
		emailView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		phoneNumberView.layer.cornerRadius = 10
		phoneNumberView.layer.masksToBounds = true
		phoneNumberView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
		birthdayView.layer.cornerRadius = 10
		birthdayView.layer.masksToBounds = true
		birthdayView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		genderView.layer.cornerRadius = 10
		genderView.layer.masksToBounds = true
		genderView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
	}
	
	//Show date picker when birthday field is selected
	func displayDatePicker() {
		datePicker.datePickerMode = .date
		datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
		
		let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
		
		let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
		let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelPressed))
		
		toolbar.setItems([cancelBtn, flexSpace, doneBtn], animated: true)
		
		birthdayView.textField.inputView = datePicker
		birthdayView.textField.inputAccessoryView = toolbar
	}

	//Show action sheet for gender when gender option is selected
	func displayGenderOptions(_ textField: UITextField) {
		let actionSheet: UIAlertController = UIAlertController(title: "Gender", message: nil, preferredStyle: .actionSheet)
		
		actionSheet.addAction(UIAlertAction(title: "Male", style: .default, handler: { (Void) in
			textField.text = "Male"
		}))
		actionSheet.addAction(UIAlertAction(title: "Female", style: .default, handler: { (Void) in
			textField.text = "Female"
		}))
		actionSheet.addAction(UIAlertAction(title: "Non-binary", style: .default, handler: { (Void) in
			textField.text = "Non-binary"
		}))
		actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (Void) in
			self.view.endEditing(true)
		}))
		
		self.present(actionSheet, animated: true, completion: nil)
	}
	
	@objc func datePickerValueChanged() {
		let formatter = DateFormatter()
		formatter.dateStyle = .long
		formatter.timeStyle = .none
		
		birthdayView.textField.text = formatter.string(from: datePicker.date)
	}
	
	@objc func donePressed() {
		let formatter = DateFormatter()
		formatter.dateStyle = .long
		formatter.timeStyle = .none
		
		birthdayView.textField.text = formatter.string(from: datePicker.date)
		self.view.endEditing(true)
	}
	
	@objc func cancelPressed() { self.view.endEditing(true) }
	
	@IBAction func cancelEdit(_ sender: Any) {
		navigationController?.popViewController(animated: true)
	}
	
	//Save values
	@IBAction func saveEdit(_ sender: Any) {
		defaults.set(firstNameView.textField.text, forKey: "firstName")
		defaults.set(lastNameView.textField.text, forKey: "lastName")
		defaults.set(emailView.textField.text, forKey: "email")
		defaults.set(phoneNumberView.textField.text, forKey: "phone")
		defaults.set(birthdayView.textField.text, forKey: "birthday")
		defaults.set(genderView.textField.text, forKey: "gender")
		
		navigationController?.popViewController(animated: true)
	}
	
}

extension PersonalViewController: UITextFieldDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		let view = textField.superview as! TextFieldView
		view.labelCenter.isActive = false
		view.labelBottom.isActive = true
		view.textFieldLabel.font = UIFont.systemFont(ofSize: 10)
		
		if textField == birthdayView.textField {
			displayDatePicker()
		}
		
		if textField == genderView.textField {
			displayGenderOptions(textField)
		}
		
		self.saveButton.isEnabled = true
		self.saveButton.tintColor = .white
		
		self.cancelButton.image = nil
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if textField == birthdayView.textField || textField == genderView.textField {
			return false
		}
		return true
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if (textField.text?.isEmpty ?? true) {
			let view = textField.superview as! TextFieldView
			view.labelBottom.isActive = false
			view.labelCenter.isActive = true
			view.textFieldLabel.font = UIFont.systemFont(ofSize: 17)
		}
	}
	
	
}
