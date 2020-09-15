//
//  NavigationController.swift
//  Workout
//
//  Created by Vatsan Prabhu on 2020-09-13.
//  Copyright © 2020 vatsan. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupNavBar()
	}
	
	func setupNavBar() {
		self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
		self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
		self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: -30)
		self.navigationController?.navigationBar.layer.shadowRadius = 10
		self.navigationController?.navigationBar.layer.shouldRasterize = true
		self.navigationController?.navigationBar.layer.rasterizationScale = UIScreen.main.scale
		self.navigationController?.navigationBar.layer.shadowPath = UIBezierPath(rect: (navigationBar.bounds)).cgPath
		
	}
}
