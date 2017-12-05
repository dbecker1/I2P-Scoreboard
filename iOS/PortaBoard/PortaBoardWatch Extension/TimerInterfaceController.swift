//
//  TimerInterfaceController.swift
//  PortaBoardWatch Extension
//
//  Created by Daniel Becker on 12/4/17.
//  Copyright © 2017 Daniel Becker. All rights reserved.
//

import WatchKit
import Foundation
import CoreBluetooth

class TimerInterfaceController: WKInterfaceController {

    @IBOutlet var minutePicker: WKInterfacePicker!
    @IBOutlet var secondPicker: WKInterfacePicker!
    @IBOutlet var startStopTimerButton: WKInterfaceButton!
    
    var timePickerItems = [WKPickerItem]()
    var selectedMinute = 0
    var selectedSecond = 0
    
    var timerStarted = false
    
    override func willActivate() {
        super.willActivate()
        for i in 0...59 {
            let pickerItem = WKPickerItem();
            if (i < 10) {
                pickerItem.title = "0\(i)"
            } else {
                pickerItem.title = "\(i)"
            }
            timePickerItems.append(pickerItem)
        }
        
        minutePicker.setItems(timePickerItems)
        secondPicker.setItems(timePickerItems)
        
    }
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        
    }
    @IBAction func setTimer() {
        if serial != nil {
            let minutes = String(format: "%02d",selectedMinute)
            let seconds = String(format: "%02d",selectedSecond)
            serial.sendMessageToDevice("TIMERSET|\(minutes):\(seconds)")
        }
        
    }
    @IBAction func startStopTimer() {
        if !timerStarted {
            if serial != nil {
                serial.sendMessageToDevice("TIMERSTART")
            }
            timerStarted = true
        } else {
            if serial != nil {
                serial.sendMessageToDevice("TIMERSTOP")
            }
            timerStarted = false
        }
    }
    @IBAction func minuteUpdated(_ value: Int) {
        selectedMinute = value
    }
    
    @IBAction func secondUpdated(_ value: Int) {
        selectedSecond = value
    }
    
}
