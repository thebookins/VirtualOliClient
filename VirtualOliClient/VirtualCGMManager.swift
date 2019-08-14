//
//  VirtualOliClientManager.swift
//  VirtualOliClient
//
//  Created by Paul Dickens on 4/12/18.
//  Copyright © 2018 Paul Dickens. All rights reserved.
//

import HealthKit
import LoopKit
import Foundation
import UIKit


public class VirtualCGMManager : CGMManager {
    public var delegateQueue: DispatchQueue!
    
    public static let managerIdentifier: String = "SimulatedCGM"

    // TODO: encapsulate all this in a class VirtualOliClient
//    let manager = SocketManager(socketURL: URL(string: "https://virtual-oli.herokuapp.com")!, config: [.log(false), .compress])
    // end TODO

    public init() {
        shareService = ShareService(keychainManager: keychain)
        
        // TODO: encapsulate all this in a class VirtualOliClient
//        let socket = manager.defaultSocket
//        let socket = manager.socket(forNamespace: "/cgm")
//        socket.on(clientEvent: .connect) {data, ack in
//            print("socket connected")
//        }
//
//        socket.on("message") {data, ack in
//            print(type(of: data[0]))
//            print(data[0])
//            guard let response = data[0] as? NSDictionary, let glucoseValue = response["glucose"] as? Double, let dateString = response["readDate"] as? String else {
//                return
//            }
//
//            guard let readDate = self.dateFormatter.date(from: dateString) else {
//                return
//            }
//
////            let glucose = VirtualOliGlucose(glucose: glucoseValue, readDate: readDate)
////
////            self.latestReading = glucose
////
////            let quantity = glucose.quantity
////
////            print("%{public}@: New glucose: %@", #function, String(describing: quantity))
////
////            self.updateDelegate(with: .newData([
////                NewGlucoseSample(
////                    date: glucose.readDate,
////                    quantity: quantity,
////                    isDisplayOnly: false,
////                    syncIdentifier: "\(Int(glucose.startDate.timeIntervalSince1970))",
////                    device: self.device
////                )
////                ]))
//
//
////
////            socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
////                socket.emit("update", ["amount": cur + 2.50])
////            }
////
////            ack.with("Got your currentAmount", "dude")
//        }
//
//        socket.connect()
//        // end TODO
        
//        self.dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    }
    
    required convenience public init?(rawState: CGMManager.RawStateValue) {
        self.init()
    }
    
    public var rawState: CGMManager.RawStateValue {
        return [:]
    }
    
    private let keychain = KeychainManager()
    
//    private let dateFormatter = DateFormatter()
    
    public var shareService: ShareService {
        didSet {
            try! keychain.setDexcomShareUsername(shareService.username, password: shareService.password, url: shareService.url)
        }
    }
    
    public static let localizedTitle = NSLocalizedString("Virtual", comment: "CGM display title")
    
    public var appURL: URL? {
        return nil
    }
    
    weak var delegate: CGMManagerDelegate?
    
    public var cgmManagerDelegate: CGMManagerDelegate? {
        get {
            return self.delegate
        }
        set {
            self.delegate = newValue
        }
    }
    
    public var providesBLEHeartbeat: Bool {
        return true
    }
    
    public var managedDataInterval: TimeInterval? {
        return nil
    }
    
    private(set) public var latestReading: Glucose? {
        get {
            return lockedLatestReading.value
        }
        set {
            lockedLatestReading.value = newValue
        }
    }
    private let lockedLatestReading: Locked<Glucose?> = Locked(nil)
    
    public var shouldSyncToRemoteService: Bool {
        return true
    }
    
    public var sensorState: SensorDisplayable? {
        return latestReading
    }
    
    public var device: HKDevice? {
        return HKDevice(
            name: "SimulatedCGM",
            manufacturer: "",
            model: "",
            hardwareVersion: nil,
            firmwareVersion: nil,
            softwareVersion: String(0.1),
            localIdentifier: nil,
            udiDeviceIdentifier: "01234567890123"
        )
    }
    
    public var debugDescription: String {
        return [
            "## \(String(describing: type(of: self)))",
            "latestReading: \(String(describing: latestReading))",
            "providesBLEHeartbeat: \(providesBLEHeartbeat)",
            ""
            ].joined(separator: "\n")
    }
    
    private func updateDelegate(with result: CGMResult) {
        if let manager = self as? CGMManager {
            delegate?.cgmManager(manager, didUpdateWith: result)
        }
    }
    
    public func fetchNewDataIfNeeded(_ completion: @escaping (LoopKit.CGMResult) -> Void) {
        print("fetching new data")
        
        let glucose = Glucose(glucose: 6.0, readDate: Date())
        let quantity = glucose.quantity
        
        completion(.newData([
            NewGlucoseSample(
                date: glucose.readDate,
                quantity: quantity,
                isDisplayOnly: false,
                syncIdentifier: "\(Int(glucose.startDate.timeIntervalSince1970))",
                device: self.device
            )
        ]))

//        GlucoseFetcher.fetchGlucose { [weak self] glucose in
//            guard let self = self else {
//                completion(.noData)
//                return
//            }
//
//            self.latestReading = glucose
//
//            let quantity = glucose.quantity
//
//            print("%{public}@: New glucose: %@", #function, String(describing: quantity))
//
//            completion(.newData([
//                NewGlucoseSample(
//                    date: glucose.readDate,
//                    quantity: quantity,
//                    isDisplayOnly: false,
//                    syncIdentifier: "\(Int(glucose.startDate.timeIntervalSince1970))",
//                    device: self.device
//                )
//            ]))
//        }
    }
}
