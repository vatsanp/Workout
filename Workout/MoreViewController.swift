//
//  MoreViewController.swift
//  Workout
//
//  Created by Vatsan Prabhu on 2020-09-11.
//  Copyright © 2020 vatsan. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {
	
	@IBOutlet var personalButton: UIButton!
	@IBOutlet var measurementsButton: UIButton!
	@IBOutlet var goalsButton: UIButton!
	
	let defaults = UserDefaults.standard
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let firstName = defaults.string(forKey: "firstName") ?? ""
		let lastName = defaults.string(forKey: "lastName") ?? ""
		
		if firstName.isEmpty && lastName.isEmpty { self.navigationItem.title = "Welcome" }
		else { self.navigationItem.title = firstName + " " + lastName }
		
		//Setup buttons
		personalButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
		personalButton.tintColor = UIColor(red: 255/255.0, green: 75/255.0, blue: 0/255.0, alpha: 1)
		measurementsButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
		measurementsButton.tintColor = UIColor(red: 255/255.0, green: 75/255.0, blue: 0/255.0, alpha: 1)
		goalsButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
		goalsButton.tintColor = UIColor(red: 255/255.0, green: 75/255.0, blue: 0/255.0, alpha: 1)
		
		personalButton.layer.borderWidth = 2
		personalButton.layer.borderColor = CGColor(srgbRed: 255/255.0, green: 75/255.0, blue: 0/255.0, alpha: 1)
		personalButton.layer.cornerRadius = 5
		personalButton.layer.masksToBounds = true
		measurementsButton.layer.borderWidth = 2
		measurementsButton.layer.borderColor = CGColor(srgbRed: 255/255.0, green: 75/255.0, blue: 0/255.0, alpha: 1)
		measurementsButton.layer.cornerRadius = 5
		measurementsButton.layer.masksToBounds = true
		goalsButton.layer.borderWidth = 2
		goalsButton.layer.borderColor = CGColor(srgbRed: 255/255.0, green: 75/255.0, blue: 0/255.0, alpha: 1)
		goalsButton.layer.cornerRadius = 5
		goalsButton.layer.masksToBounds = true
		
		personalButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
		measurementsButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
		goalsButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
	}
}
