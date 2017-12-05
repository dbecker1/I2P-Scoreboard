//
//  ScoreboardViewController.swift
//  PortaBoard
//
//  Created by Daniel Becker on 9/6/17.
//  Copyright © 2017 Daniel Becker. All rights reserved.
//

import UIKit
import CoreBluetooth

class ScoreboardViewController: UIViewController, BluetoothSerialDelegate {
    
    @IBOutlet weak var timerTextField: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    var timerMinutes = 0
    var timerSeconds = 0
    
    let feedbackGenerator = UISelectionFeedbackGenerator()
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: UIImpactFeedbackStyle.medium)
    let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
    
    enum TimerState { case start, stop }
    var timerState: TimerState = .start
    @IBOutlet weak var timerToggleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        outputLabel.text = nil
        
        let timerPickerView = TimerPickerView(frame: timerTextField.textInputView.frame)
        timerPickerView.changeCallback = { [unowned self](component, row) in
            if component == 0 {
                // Then change minutes
                self.timerMinutes = row
            } else {
                // Change seconds
                self.timerSeconds = row
            }
            self.timerValueDidChange()
        }
        
        let toolBar: UIToolbar = UIToolbar()
        toolBar.barStyle = UIBarStyle.black
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let done = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(dismissKeyboard))
        
        let textInputAccessories = [flexibleSpace, done]
        
        toolBar.sizeToFit()
        toolBar.items = textInputAccessories
        timerTextField.inputAccessoryView = toolBar
        timerTextField.inputView = timerPickerView
        timerPickerView.backgroundColor = UIColor.black
        timerTextField.backgroundColor = UIColor.black
            
        serial = BluetoothSerial.init(delegate: self)
        
        if serial.centralManager.state != .poweredOn {
            outputLabel.text = "Error: Unable to enable Bluetooth"
            return
        } else {
            outputLabel.text = "Bluetooth Searching"
        }
        
        serial.startScan()
    }


    @IBAction func increaseHomeScore(_ sender: UIButton) {
        if serial != nil {
            feedbackGenerator.selectionChanged()
            serial.sendMessageToDevice("SCORE|H|U")
        }
    }
    
    @IBAction func decreaseHomeScore(_ sender: UIButton) {
        if serial != nil {
            feedbackGenerator.selectionChanged()
            serial.sendMessageToDevice("SCORE|H|D")
        }
    }
    
    @IBAction func increaseAwayScore(_ sender: UIButton) {
        if serial != nil {
            feedbackGenerator.selectionChanged()
            serial.sendMessageToDevice("SCORE|A|U")
        }
    }
    
    @IBAction func decreaseAwayScore(_ sender: UIButton) {
        if serial != nil {
            feedbackGenerator.selectionChanged()
            serial.sendMessageToDevice("SCORE|A|D")
        }
    }

    
    func serialDidChangeState() {
        print(serial.centralManager.state)
        if serial.centralManager.state == .poweredOn {
            serial.startScan()
            outputLabel.text = "Bluetooth Searching"
        }
        print("Serial Changed State")
    }
    
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        print("Serial Did Disconnect")
        outputLabel.text = "Bluetooth Disconnected"
    }
    
    func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?) {
        if peripheral.name == "PortaBoard" {
            serial.connectToPeripheral(peripheral)
            outputLabel.text = "PortaBoard Connected"
        }
        print("Peripheral discovered")
    }
    
}


/*
 * Handle the Timer: inputting the time, setting the timer, and starting/stopping the timer
 */
extension ScoreboardViewController: UITextFieldDelegate {
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func timerValueDidChange() {
        let minutes = String(format: "%02d", timerMinutes)
        let seconds = String(format: "%02d", timerSeconds)
        self.timerTextField.text = "\(minutes):\(seconds)"
    }
    
    
    @IBAction func setTimer(_ sender: UIButton) {
        if serial != nil {
            impactFeedbackGenerator.impactOccurred()
            let minutes = String(format: "%02d", timerMinutes)
            let seconds = String(format: "%02d", timerSeconds)
            serial.sendMessageToDevice("TIMERSET|\(minutes):\(seconds)")
        }
    }
    
    @IBAction func toggleTimerState(_ sender: UIButton) {
        
        if timerState == .start {
            timerState = .stop
            notificationFeedbackGenerator.notificationOccurred(.success)
            let redColor = UIColor(red: 255.0/255.0, green: 45.0/255.0, blue: 85.0/255.0, alpha: 1)
            UIView.animate(withDuration: 0.5, animations: {
                self.timerToggleButton.backgroundColor = redColor
                self.timerToggleButton.setTitle("STOP", for: .normal)
            })
            
            if serial != nil {
                serial.sendMessageToDevice("TIMERSTART")
            }
        } else {
            
            feedbackGenerator.selectionChanged()
            timerState = .start
            let blueColor = UIColor(red: 64.0/255.0, green: 143.0/255.0, blue: 247.0/255.0, alpha: 1)
            UIView.animate(withDuration: 0.5, animations: {
                self.timerToggleButton.backgroundColor = blueColor
                self.timerToggleButton.setTitle("START", for: .normal)
            })
            
            if serial != nil {
                serial.sendMessageToDevice("TIMERSTOP")
            }
        }
    }
    
}
