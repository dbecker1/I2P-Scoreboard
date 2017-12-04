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

    @IBOutlet var outputText: WKInterfaceLabel!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        serial = BluetoothSerial.init(delegate: self)
        
        if serial.centralManager.state != .poweredOn {
            outputText.setText("Error: Unable to enable Bluetooth.")
            return
        } else {
            outputText.setText("Bluetooth Searching.")
        }
        
        serial.startScan()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func serialDidChangeState() {
        print(serial.centralManager.state)
        if serial.centralManager.state == .poweredOn {
            serial.startScan()
            outputText.setText("Bluetooth Searching.")
        }
        print("Serial Changed State")
    }
    
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        print("Serial Did Disconnect")
        outputText.setText("Bluetooth Disconnected.")
    }
    
    func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?) {
        if peripheral.name == "PortaBoard" {
            serial.connectToPeripheral(peripheral)
            outputText.setText("PortaBoard Connected")
        }
        print("Peripheral discovered")
    }

}
