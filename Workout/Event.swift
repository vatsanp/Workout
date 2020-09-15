//
//  Event.swift
//  Workout
//
//  Created by Vatsan Prabhu on 2020-09-12.
//  Copyright © 2020 vatsan. All rights reserved.
//

import UIKit

class Event: NSObject, Encodable, Decodable {
	override func isEqual(_ object: Any?) -> Bool {
		let obj = object as? Event
		
		return title == obj?.title &&
			time == obj?.time &&
			location == obj?.location &&
			eventType == obj?.eventType
	}
	

	var title: String
	var time: DateInterval
	var capacity: Int
	var registered: Int
	var location: String
	var eventType: String
	var myEvent: Bool

	override init() {
		let formatter = DateFormatter()
		formatter.dateFormat = "h:mm a"
		let start = formatter.date(from: "12:00 AM")
		let end = Calendar.current.date(byAdding: .hour, value: 1, to: start!)
		
		self.title = "Event"
		self.time = DateInterval(start: start!, end: end!)
		self.capacity = 0
		self.registered = 0
		self.location = ""
		self.eventType = "Event"
		self.myEvent = false

	}

	init(title: String, time: DateInterval, capacity: Int, registered: Int, location: String, eventType: String, myEvent: Bool) {
		self.title = title
		self.time = time
		self.capacity = capacity
		self.registered = registered
		self.location = location
		self.eventType = eventType
		self.myEvent = myEvent
	}

}
