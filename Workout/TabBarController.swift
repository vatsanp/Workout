//
//  TabBarController.swift
//  Workout
//
//  Created by Vatsan Prabhu on 2020-09-13.
//  Copyright © 2020 vatsan. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupTabBar()
	}
	
	func setupTabBar() {
		tabBar.layer.shadowColor = UIColor.black.cgColor
		tabBar.layer.shadowOpacity = 0.5
		tabBar.layer.shadowOffset = CGSize(width: 0, height: 10)
		tabBar.layer.shadowRadius = 10
		tabBar.layer.shouldRasterize = true
		tabBar.layer.rasterizationScale = UIScreen.main.scale
		tabBar.layer.shadowPath = UIBezierPath(rect: (tabBar.bounds)).cgPath
		
		let appearance = tabBar.standardAppearance
		appearance.configureWithOpaqueBackground()
		appearance.shadowImage = nil
		appearance.shadowColor = nil
		tabBar.standardAppearance = appearance
	}
}
