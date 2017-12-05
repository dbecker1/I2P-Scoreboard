//
//  InterfaceController.swift
//  PortaBoardWatch Extension
//
//  Created by Daniel Becker on 11/27/17.
//  Copyright © 2017 Daniel Becker. All rights reserved.
//

import WatchKit
import Foundation
import CoreBluetooth

class ScoreboardInterfaceController: WKInterfaceController, BluetoothSerialDelegate {

    @IBOutlet var label: WKInterfaceLabel!
    //@IBOutlet var outputText: WKInterfaceLabel!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        serial = BluetoothSerial.init(delegate: self)
        
        if serial.centralManager.state != .poweredOn {
            label.setText("Not Enabled.")
            print("Unable to enable bluetooth")
            return
        } else {
            label.setText("Searching.")
            print("Bluetooth Searching")
        }
        
        serial.startScan()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func increaseHomeScore() {
        if serial != nil {
            serial.sendMessageToDevice("SCORE|H|U")
        }
    }
    
    @IBAction func decreaseHomeScore() {
        if serial != nil {
            serial.sendMessageToDevice("SCORE|H|D")
        }
    }
    @IBAction func increaseAwayScore() {
        if serial != nil {
            serial.sendMessageToDevice("SCORE|A|U")
        }
    }
    @IBAction func decreaseAwayScore() {
        if serial != nil {
            serial.sendMessageToDevice("SCORE|A|D")
        }
    }
    
    func serialDidChangeState() {
        print(serial.centralManager.state)
        if serial.centralManager.state == .poweredOn {
            serial.startScan()
            label.setText("Searching.")
            print("Bluetooth Searching")
        }
        print("Serial Changed State")
    }
    
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        print("Serial Did Disconnect")
        label.setText("Disconnected.")
    }
    
    func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?) {
        if peripheral.name == "PortaBoard" {
            serial.connectToPeripheral(peripheral)
            label.setText("PortaBoard")
            print("PortaBoard Connected")
        }
        print("Peripheral discovered")
    }

}
