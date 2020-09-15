//
//  HomeViewController.swift
//  Workout
//
//  Created by Vatsan Prabhu on 2020-09-15.
//  Copyright © 2020 vatsan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
	
	@IBOutlet var bookButton: UIButton!
	@IBOutlet var upNextView: UIStackView!
	@IBOutlet var tipsView: UIStackView!
	
	var myEvents: [Date:[Event]]!
	var sortedDates: [Date]!
	
	let defaults = UserDefaults.standard
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Get events
		let events = defaults.object(forKey: "myEvents")
		if events != nil {
			if let decodedData = try? PropertyListDecoder().decode([Date:[Event]].self, from:  events as! Data) {
				myEvents = decodedData
				sortedDates = Array(myEvents.keys).sorted()
			}
			else { print("Unable to retrieve events") }
		}
		
		bookButton.backgroundColor = UIColor(red: 255/255.0, green: 75/255.0, blue: 0/255.0, alpha: 1)
		bookButton.tintColor = .white
		bookButton.layer.cornerRadius = 5
		bookButton.layer.masksToBounds = true
		
		//Set next event on home page
		let eventView = getUpNext()
		if eventView != nil {
			for view in upNextView.subviews {
				view.removeFromSuperview()
			}
			upNextView.addArrangedSubview(eventView!)
		}
		
		//Set recommended tip on home page
		let recommended = getRecommended()
		if recommended != nil {
			for view in tipsView.subviews {
				view.removeFromSuperview()
			}
			let tip = UILabel()
			if recommended == "Gym" { tip.text = "Go to the gym to get your strength up!" }
			else if recommended == "Pool" { tip.text = "Book your spot in the pool to get some endurance training in" }
			else { tip.text = "Sign up for a class with a friend to get fit together!" }
			tipsView.addArrangedSubview(tip)
			
			tip.leadingAnchor.constraint(equalTo: tipsView.leadingAnchor, constant: 10).isActive = true
			tip.numberOfLines = 0
			tip.textAlignment = .center
		}
	}
	
	//Get next event in calendar
	func getUpNext() -> EventView? {
		let currentDate = Date()
		var nextDate: Date!
		var nextEvent: Event!

		if sortedDates == nil { return nil }
		for date in sortedDates {
			if date >= currentDate {
				nextDate = date
				break
			}
		}
		if nextDate == nil { return nil }
		let events = myEvents[nextDate]!.sorted(by: { $0.time.start > $1.time.start })
		
		let date = Date()
		let calendar = Calendar.current
		let hour = calendar.component(.hour, from: date)
		
		if nextDate == currentDate {
			for event in events {
				if event.time.start.get(.hour) > hour {
					nextEvent = event
					break
				}
			}
		}
		else if nextDate > currentDate { nextEvent = events[0] }
		else { return nil }
		
		return EventView(event: nextEvent)
	}
	
	//Get recommended tip from event type with least activity
	func getRecommended() -> String? {
		var minEventType: String
		
		if myEvents == nil { return nil }
		let events = Array(myEvents.values).reduce([], +)
		let gymCount = Double(events.filter({ $0.eventType == "Gym" }).count)
		let poolCount = Double(events.filter({ $0.eventType == "Pool" }).count)
		let classesCount = Double(events.filter({ $0.eventType == "Classes" }).count)
		
		let minCount = min(min(poolCount, classesCount), gymCount)
		if minCount == gymCount { minEventType = "Gym" }
		else if minCount == poolCount { minEventType = "Pool" }
		else { minEventType = "Classes" }
		
		return minEventType
	}
	
	
	@IBAction func goToBookings(_ sender: Any) {
		self.tabBarController?.selectedIndex = 1
	}
	
	@IBAction func goToActivity(_ sender: Any) {
		self.tabBarController?.selectedIndex = 2
	}
	
}

extension Date {
	func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
		return calendar.component(component, from: self)
	}
}
