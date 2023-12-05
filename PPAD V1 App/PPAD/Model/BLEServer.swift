//
//  BLEServer.swift
//  PPAD
//
//  Created by Roberto Chadwick on 11/27/23.
//

import Foundation
import CoreBluetooth

class BLEServer: NSObject, CBPeripheralManagerDelegate {
    private var peripheralManager: CBPeripheralManager!
    private let serviceUUID = CBUUID(string: "0a1cdd59-0db2-4402-a8c1-688a3b02c6e1") // SET YOU OWN UNIQUE UUID, THESE ARE TEMPS
    private let characteristicUUID = CBUUID(string: "d247abef-c376-4287-81ef-192b0801f960") //SET YOUR OWN UNIQUE UUID
    private var notifyCharacteristic: CBMutableCharacteristic?
    
    public var isDeviceConnected: Bool = false
    
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func startAdvertising() {
        if peripheralManager.isAdvertising {
            print("Already advertising")
            return
        }
        
        let service = CBMutableService(type: serviceUUID, primary: true)
        
        let properties: CBCharacteristicProperties = [.notify]
        let permissions: CBAttributePermissions = []
        notifyCharacteristic = CBMutableCharacteristic(
            type: characteristicUUID,
            properties: properties,
            value: nil,
            permissions: permissions
        )
        
        service.characteristics = [notifyCharacteristic!]
        
        peripheralManager.add(service)
        let advertisementData = [CBAdvertisementDataServiceUUIDsKey: [serviceUUID]]
        peripheralManager.startAdvertising(advertisementData)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            print("BLE powered on")
            startAdvertising()
        default:
            print("BLE state: \(peripheral.state.rawValue)")
        }
    }
    
    func updateAndNotify(value: String) {
        guard let characteristic = notifyCharacteristic,
              let dataValue = value.data(using: .utf8) else {return}
        
        let didSendValue = peripheralManager.updateValue(dataValue, for: characteristic, onSubscribedCentrals: nil)
        
        if !didSendValue {
            print("Failed to send value")
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
            print("Central subscribed to characteristic")
            isDeviceConnected = true
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
            print("Central unsubscribed from characteristic")
            isDeviceConnected = false
    }
}
