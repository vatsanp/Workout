//
//  TextFieldView.swift
//  Workout
//
//  Created by Vatsan Prabhu on 2020-08-31.
//  Copyright © 2020 vatsan. All rights reserved.
//

import Foundation
import UIKit

class TextFieldView: UIView{
	
	@IBOutlet var textFieldLabel: UILabel!
	@IBOutlet var textField: UITextField!
	
	@IBOutlet var labelCenter: NSLayoutConstraint!
	@IBOutlet var labelBottom: NSLayoutConstraint!
	
	
	//initWithFrame to init view from code
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	//initWithCode to init view from xib or storyboard
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}

