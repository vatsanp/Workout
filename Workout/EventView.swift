//
//  EventView.swift
//  Workout
//
//  Created by Vatsan Prabhu on 2020-09-12.
//  Copyright © 2020 vatsan. All rights reserved.
//

import UIKit

class EventView: UIView {
	
	var event: Event!
	var startLabel: UILabel! = UILabel()
	var endLabel: UILabel! = UILabel()
	var eventCard: UIView! = UILabel()
	var titleLabel: UILabel! = UILabel()
	var capacityLabel: UILabel! = UILabel()
	var availabilityLabel: UILabel! = UILabel()
	var locationLabel: UILabel! = UILabel()
	var eventTypeLabel: UILabel! = UILabel()
	
	convenience init(event: Event) {
		let width = UIScreen.main.bounds.width - 10
		
		self.init(event: event, frame: CGRect(x: 0, y: 0, width: width, height: 200))

	}
	
	//Set up custom view
	init(event: Event, frame: CGRect) {
		super.init(frame: frame)
		
		let df = DateFormatter()
		df.dateFormat = "h:mm a"
		
		self.eventCard = UIView(frame: CGRect(x: 0, y: 0, width: frame.width/4*3, height: self.frame.height))
		self.event = event
		self.titleLabel.text = event.title.uppercased()
		self.startLabel.text = df.string(from: event.time.start)
		self.endLabel.text = df.string(from: event.time.end)
		self.capacityLabel.text = "\(event.registered) / \(event.capacity)"
		self.locationLabel.text = "Ottawa"
		self.eventTypeLabel.text = event.eventType
		
		if event.myEvent {
			self.availabilityLabel.text = " Registered "
			self.availabilityLabel.backgroundColor = UIColor(red: 255/255.0, green: 75/255.0, blue: 0/255.0, alpha: 1)
		}
		else {
			self.availabilityLabel.text = event.registered < event.capacity ? " Available " : " Full "
			availabilityLabel.backgroundColor = event.registered < event.capacity ? .systemGreen : .systemRed
		}
		
		self.translatesAutoresizingMaskIntoConstraints = false
		eventCard.translatesAutoresizingMaskIntoConstraints = false
		startLabel.translatesAutoresizingMaskIntoConstraints = false
		endLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		locationLabel.translatesAutoresizingMaskIntoConstraints = false
		eventTypeLabel.translatesAutoresizingMaskIntoConstraints = false
		availabilityLabel.translatesAutoresizingMaskIntoConstraints = false
		capacityLabel.translatesAutoresizingMaskIntoConstraints = false
		
		titleLabel.font = .boldSystemFont(ofSize: 16)
		eventTypeLabel.font = .systemFont(ofSize: 12)
		eventTypeLabel.textColor = .systemGray
		endLabel.textColor = .systemGray
		
		availabilityLabel.textColor = .white
		availabilityLabel.font = .boldSystemFont(ofSize: 16)
		availabilityLabel.layer.cornerRadius = 5
		availabilityLabel.layer.masksToBounds = true
		
		eventCard.backgroundColor = .white
		eventCard.layer.borderWidth = 2
		eventCard.layer.borderColor = CGColor(srgbRed: 255/255.0, green: 75/255.0, blue: 0/255.0, alpha: 1)
		eventCard.layer.cornerRadius = 10
		eventCard.layer.masksToBounds = true
		
		
		
		eventCard.addSubview(titleLabel)
		eventCard.addSubview(capacityLabel)
		eventCard.addSubview(availabilityLabel)
		eventCard.addSubview(locationLabel)
		eventCard.addSubview(eventTypeLabel)
		self.addSubview(eventCard)
		self.addSubview(startLabel)
		self.addSubview(endLabel)
		
		
		
		let constraints = [
			startLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
			startLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
			startLabel.trailingAnchor.constraint(equalTo: eventCard.leadingAnchor),
			startLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/4),
			endLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
			endLabel.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: 5),
			endLabel.trailingAnchor.constraint(equalTo: eventCard.leadingAnchor),
			endLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/4),
			eventCard.topAnchor.constraint(equalTo: self.topAnchor),
			eventCard.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
			eventCard.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: eventCard.leadingAnchor, constant: 10),
			titleLabel.topAnchor.constraint(equalTo: eventCard.topAnchor, constant: 10),
			eventTypeLabel.leadingAnchor.constraint(equalTo: eventCard.leadingAnchor, constant: 10),
			eventTypeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
			locationLabel.leadingAnchor.constraint(equalTo: eventCard.leadingAnchor, constant: 10),
			//locationLabel.topAnchor.constraint(equalTo: eventTypeLabel.bottomAnchor, constant: 10),
			locationLabel.bottomAnchor.constraint(equalTo: eventCard.bottomAnchor, constant: -10),
			availabilityLabel.topAnchor.constraint(equalTo: eventCard.topAnchor, constant: 10),
			availabilityLabel.trailingAnchor.constraint(equalTo: eventCard.trailingAnchor, constant: -10),
			capacityLabel.topAnchor.constraint(equalTo: availabilityLabel.bottomAnchor, constant: 10),
			capacityLabel.trailingAnchor.constraint(equalTo: eventCard.trailingAnchor, constant: -10),
			self.heightAnchor.constraint(equalToConstant: 100)
		]
		
		NSLayoutConstraint.activate(constraints)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setMyEvent() {
		self.event.myEvent = true
		self.event.registered += 1
		self.availabilityLabel.text = " Registered "
		self.availabilityLabel.backgroundColor = UIColor(red: 255/255.0, green: 75/255.0, blue: 0/255.0, alpha: 1)
		self.capacityLabel.text = "\(self.event.registered) / \(self.event.capacity)"
	}
	
	func unsetMyEvent() {
		self.event.myEvent = false
		self.event.registered -= 1
		if self.event.registered < self.event.capacity {
			self.availabilityLabel.text = " Available "
			self.availabilityLabel.backgroundColor = .systemGreen
		}
		else {
			self.availabilityLabel.text = " Full "
			self.availabilityLabel.backgroundColor = .systemRed
		}
		self.capacityLabel.text = "\(self.event.registered) / \(self.event.capacity)"
	}
	
	@objc func eventClick(_ sender: UITapGestureRecognizer) {
		print("Tapped")
	}
}
