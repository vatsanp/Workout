//
//  CalendarViewController.swift
//  Workout
//
//  Created by Vatsan Prabhu on 2020-09-09.
//  Copyright © 2020 vatsan. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, UIGestureRecognizerDelegate, FSCalendarDelegate, FSCalendarDataSource {
	
	@IBOutlet var calendar: FSCalendar!
	@IBOutlet var eventsView: UIStackView!
	@IBOutlet var scopeButton: UIBarButtonItem!
	@IBOutlet var switchButton: UIBarButtonItem!
	@IBOutlet var todayButton: UIBarButtonItem!
	@IBOutlet var filterButton: UIButton!
	
	@IBOutlet var calendarHeight: NSLayoutConstraint!
	
	var selectedDate: Date!
	var personal: Bool = false
	var sampleEvents: [Event]!
	var myEvents: [Date:[Event]]!
	
	let defaults = UserDefaults.standard
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		myEvents = [:]
		
		//Use sample events for now
		sampleEvents = getSampleEvents()
		
		//Get events
		let events = defaults.object(forKey: "myEvents")
		if events != nil {
			if let decodedData = try? PropertyListDecoder().decode([Date:[Event]].self, from: defaults.object(forKey: "myEvents") as! Data) {
				myEvents = decodedData
			}
			else { print("Unable to retrieve events") }
		}

		
		eventsView.spacing = 25
		
		setupCalendar()
		
		filterButton.backgroundColor = UIColor(red: 255/255.0, green: 75/255.0, blue: 0/255.0, alpha: 1)
		filterButton.titleLabel?.font = .boldSystemFont(ofSize: 12)
		filterButton.layer.cornerRadius = 10
		filterButton.layer.masksToBounds = true
		
		selectedDate = calendar.today
		calendar.select(selectedDate)
		loadEvents(for: selectedDate)
	}
	
	//Set up calendar view
	func setupCalendar() {
		calendar.dataSource = self
		calendar.delegate = self
		calendar.scope = .week
		calendar.headerHeight = 0
		calendar.scrollDirection = .vertical
		calendar.placeholderType = .none
		calendar.appearance.selectionColor = UIColor(red: 255/255.0, green: 75/255.0, blue: 0/255.0, alpha: 1)
		calendar.appearance.weekdayTextColor = UIColor(red: 255/255.0, green: 75/255.0, blue: 0/255.0, alpha: 1)
		calendar.appearance.headerTitleColor = UIColor(red: 255/255.0, green: 75/255.0, blue: 0/255.0, alpha: 1)
		calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 20)
		calendar.appearance.todayColor = nil
		calendar.appearance.titleTodayColor = calendar.appearance.titleDefaultColor
		
		calendar.layer.shadowColor = UIColor.black.cgColor
		calendar.layer.shadowOpacity = 0.5
		calendar.layer.shadowOffset = CGSize(width: 0, height: -10)
		calendar.layer.shadowRadius = 10
		calendar.layer.shouldRasterize = true
		calendar.layer.rasterizationScale = UIScreen.main.scale
		
		self.view.addSubview(calendar)
	}
	
	//Generate sample events to use for now
	func getSampleEvents() -> [Event] {
		var events: [Event] = []
		let startTimes: [String] = ["6:00 AM", "7:30 AM", "8:00 AM", "10:00 AM", "12:00 PM", "12:00 PM", "2:30 PM", "5:00 PM", "7:30 PM", "9:00 PM", "10:00 PM"]
		let titles: [String] = ["Workout", "Zumba", "Swim", "Workout", "Workout", "Yoga", "Spinning", "Workout", "Swim", "Yoga", "Workout"]
		let types: [String] = ["Gym", "Classes", "Pool", "Gym", "Gym", "Classes", "Classes", "Gym", "Pool", "Classes", "Gym"]
		
		let formatter = DateFormatter()
		formatter.dateFormat = "h:mm a"
		
		for i in 0...startTimes.count-1 {
			let start = formatter.date(from: startTimes[i])
			let end = Calendar.current.date(byAdding: .hour, value: 1, to: start!)
			
			let event = Event(title: titles[i], time: DateInterval(start: start!, end: end!), capacity: 50, registered: 0, location: "Ottawa", eventType: types[i], myEvent: false)
			events.append(event)
		}
		
		return events
	}
	
	//Load events into stack view
	func loadEvents(for date: Date) {
		let personalEvents = myEvents != nil ? myEvents[date] ?? [] : []
		let sampleEvents = getSampleEvents()
		var sortedEvents: [Event]
		
		if personal {
			sortedEvents = personalEvents.sorted(by: {$0.time.start < $1.time.start})
		}
		else {
			sortedEvents = sampleEvents.sorted(by: {$0.time.start < $1.time.start})
			for i in 0...sortedEvents.count-1 {
				if personalEvents.contains(sortedEvents[i]) {
					sortedEvents[i] = personalEvents.first(where: { $0.isEqual(sortedEvents[i]) })!
				}
			}
		}
		
		eventsView.removeAllArrangedSubviews()
		
		for event in sortedEvents {
			let eventView = EventView(event: event)
			
			let tap = UITapGestureRecognizer(target: self, action: #selector(eventClicked(_:)))
			eventView.addGestureRecognizer(tap)
			
			eventsView.addArrangedSubview(eventView)
		}
	}
	
	//Provide option to add/remove event when clicked
	@objc func eventClicked(_ sender: UITapGestureRecognizer) {
		let view = sender.view as! EventView
		
		if personal || ((myEvents[selectedDate]?.contains(view.event)) != nil) {
			let alert = UIAlertController(title: "Remove Booking?", message: nil, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { (Void) in
				view.unsetMyEvent()
				if let index = self.myEvents[self.selectedDate]?.firstIndex(of: view.event) {
					self.myEvents[self.selectedDate]?.remove(at: index)
					if self.myEvents[self.selectedDate] == [] { self.myEvents[self.selectedDate] = nil }
				}
				if let encodedData = try? PropertyListEncoder().encode(self.myEvents) {
					self.defaults.set(encodedData, forKey: "myEvents")
				}
				else { print("Unable to store events") }
			}))
			alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
		else {
			let alert = UIAlertController(title: "Confirm Booking?", message: nil, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (Void) in
				view.setMyEvent()
				if self.myEvents[self.selectedDate] == nil { self.myEvents[self.selectedDate] = [view.event] }
				else { self.myEvents[self.selectedDate]?.append(view.event) }
				
				if let encodedData = try? PropertyListEncoder().encode(self.myEvents) {
					self.defaults.set(encodedData, forKey: "myEvents")
				}
				else { print("Unable to store events") }
				
				self.switchCalendars(self)
			}))
			alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
			self.present(alert, animated: true, completion: nil)
			
		}
	}
	
	//Change calendar weekly/monthly view
	@IBAction func toggleScope(_ sender: Any) {
		if calendar.scope == .week {
			calendar.headerHeight = 47
			
			UIView.animate(withDuration: 0.3) {
				self.view.layoutIfNeeded()
			}
			
			calendar.setScope(.month, animated: true)
			
			calendar.layer.cornerRadius = 10
		}
		else if calendar.scope == .month {
			calendar.headerHeight = 0
			
			UIView.animate(withDuration: 0.3) {
				self.view.layoutIfNeeded()
			}
			
			calendar.setScope(.week, animated: true)
			
			calendar.layer.cornerRadius = 0
		}
	}
	
	//Switch between personal and general calendars
	@IBAction func switchCalendars(_ sender: Any) {
		personal.toggle()
		if personal { self.navigationItem.title = "Calendar" }
		else { self.navigationItem.title = "Bookings" }
		
		loadEvents(for: selectedDate)
		
	}
	
	//Go to today on calendar
	@IBAction func selectToday(_ sender: Any) {
		calendar.select(calendar.today)
	}
	
}

extension CalendarViewController {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
	
	func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
		self.calendarHeight.constant = bounds.height
		self.view.layoutIfNeeded()
		
		if calendar.scope == .week { calendar.layer.shadowPath = UIBezierPath(rect: calendar.bounds).cgPath }
	}
	
	func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
		if self.calendar.scope == .month { toggleScope(self) }
		self.selectedDate = date
		loadEvents(for: self.selectedDate)
	}
}

extension UIStackView {
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
            NSLayoutConstraint.deactivate($0.constraints)
            $0.removeFromSuperview()
        }
    }
}
