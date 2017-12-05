//
//  TimerPickerView.swift
//  PortaBoard
//
//  Created by Cliff Panos on 12/4/17.
//  Copyright © 2017 Daniel Becker. All rights reserved.
//

import UIKit

class TimerPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    var changeCallback: ((Int, Int) -> Void)? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.dataSource = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.dataSource = self
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let timeDescription = component == 0 ? "Minutes" : "Seconds"
        let string = "\(row) " + timeDescription
        let attributedString = NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName:UIColor.white])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let callback = changeCallback {
            callback(component, row)
        }
    }

}
