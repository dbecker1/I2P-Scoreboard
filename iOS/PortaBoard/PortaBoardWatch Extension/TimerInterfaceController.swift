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
    
    enum TimerState { case start, stop }
    var timerState: TimerState = .start
    
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
        WKInterfaceDevice.current().play(.click)
        if serial != nil {
            let minutes = String(format: "%02d",selectedMinute)
            let seconds = String(format: "%02d",selectedSecond)
            serial.sendMessageToDevice("TIMERSET|\(minutes):\(seconds)")
        }
        
    }
    @IBAction func startStopTimer() {
        
        
        if timerState == .start {
            WKInterfaceDevice.current().play(.stop)
            timerState = .stop
            let redColor = UIColor(red: 255.0/255.0, green: 45.0/255.0, blue: 85.0/255.0, alpha: 1)
            self.animate(withDuration: 0.5, animations: {
                self.startStopTimerButton.setBackgroundColor(redColor)
                self.startStopTimerButton.setTitle("STOP")
            })
            
            if serial != nil {
                serial.sendMessageToDevice("TIMERSTART")
            }
        } else {
            WKInterfaceDevice.current().play(.start)
            timerState = .start
            let blueColor = UIColor(red: 64.0/255.0, green: 143.0/255.0, blue: 247.0/255.0, alpha: 1)
            self.animate(withDuration: 0.5, animations: {
                self.startStopTimerButton.setBackgroundColor(blueColor)
                self.startStopTimerButton.setTitle("START")
            })
            
            if serial != nil {
                serial.sendMessageToDevice("TIMERSTOP")
            }
        }
    }
    @IBAction func minuteUpdated(_ value: Int) {
        WKInterfaceDevice.current().play(.click)
        
        selectedMinute = value
    }
    
    @IBAction func secondUpdated(_ value: Int) {
        WKInterfaceDevice.current().play(.click)
        
        selectedSecond = value
    }
    
}
