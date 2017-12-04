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
    
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var timerMinutes: UITextField!
    @IBOutlet weak var timerSeconds: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serial = BluetoothSerial.init(delegate: self)
        
        if serial.centralManager.state != .poweredOn {
            outputLabel.text = "Error: Unable to enable Bluetooth."
            return
        } else {
            outputLabel.text = "Bluetooth Searching."
        }
        
        serial.startScan()
    }


    @IBAction func increaseHomeScore(_ sender: UIButton) {
        if serial != nil {
            serial.sendMessageToDevice("SCORE|H|U")
        }
    }
    
    @IBAction func decreaseHomeScore(_ sender: UIButton) {
        if serial != nil {
            serial.sendMessageToDevice("SCORE|H|D")
        }
    }
    
    @IBAction func increaseAwayScore(_ sender: UIButton) {
        if serial != nil {
            serial.sendMessageToDevice("SCORE|A|U")
        }
    }
    
    @IBAction func decreaseAwayScore(_ sender: UIButton) {
        if serial != nil {
            serial.sendMessageToDevice("SCORE|A|D")
        }
    }
    
    @IBAction func setTimer(_ sender: UIButton) {
        if serial != nil {
            let minutes = String(format: "%02d",Int(timerMinutes.text!)!)
            let seconds = String(format: "%02d",Int(timerSeconds.text!)!)
            serial.sendMessageToDevice("TIMERSET|\(minutes):\(seconds)")
        }
    }
    
    @IBAction func startTimer(_ sender: UIButton) {
        if serial != nil {
            serial.sendMessageToDevice("TIMERSTART")
        }
    }
    
    @IBAction func stopTimer(_ sender: UIButton) {
        if serial != nil {
            serial.sendMessageToDevice("TIMERSTOP")
        }
    }
    
    func serialDidChangeState() {
        print(serial.centralManager.state)
        if serial.centralManager.state == .poweredOn {
            serial.startScan()
            outputLabel.text = "Bluetooth Searching."
        }
        print("Serial Changed State")
    }
    
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        print("Serial Did Disconnect")
        outputLabel.text = "Bluetooth Disconnected."
    }
    
    func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?) {
        if peripheral.name == "PortaBoard" {
            serial.connectToPeripheral(peripheral)
            outputLabel.text = "PortaBoard Connected";
        }
        print("Peripheral discovered")
    }
    
}
