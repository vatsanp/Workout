//
//  GoalsViewController.swift
//  Workout
//
//  Created by Vatsan Prabhu on 2020-09-15.
//  Copyright © 2020 vatsan. All rights reserved.
//

import UIKit

class GoalsViewController: UIViewController {
	
	@IBOutlet var weightButton: UIButton!
	@IBOutlet var strengthButton: UIButton!
	@IBOutlet var muscleButton: UIButton!
	@IBOutlet var enduranceButton: UIButton!
	@IBOutlet var flexibilityButton: UIButton!
	@IBOutlet var otherButton: UIButton!
	
	var buttonGroup: [UIButton]!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		buttonGroup = [weightButton, strengthButton, muscleButton, enduranceButton, flexibilityButton, otherButton]
		
		for button in buttonGroup {
			button.setImage(UIImage(systemName: "circle"), for: .normal)
			button.setImage(UIImage(systemName: "circle.fill"), for: .selected)
		}
		
		weightButton.layer.cornerRadius = 5
		weightButton.layer.masksToBounds = true
		weightButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		otherButton.layer.cornerRadius = 5
		otherButton.layer.masksToBounds = true
		otherButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
	}
	
	@IBAction func buttonClick (_ sender: UIButton) {
		for button in buttonGroup {
			button.isSelected = false
			button.titleLabel?.font = .systemFont(ofSize: 16)
		}
		
		sender.isSelected = true
		sender.titleLabel?.font = .boldSystemFont(ofSize: 16)
	}
}
