//
//  VirtualOliClientManager.swift
//  VirtualOliClient
//
//  Created by Paul Dickens on 4/12/18.
//  Copyright © 2018 Paul Dickens. All rights reserved.
//

import HealthKit
import LoopKit


public class VirtualOliClientManager : CGMManager {
    public required init() {
    }
    
    required convenience public init?(rawState: CGMManager.RawStateValue) {
        self.init()
    }
    
    public var rawState: CGMManager.RawStateValue {
        return [:]
    }
    
    public static let managerIdentifier: String = "SimulatedCGM"
    
    public static let localizedTitle = NSLocalizedString("Simulated CGM", comment: "CGM display title")
    
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
    
//    private(set) public var latestReading: Glucose? {
//        get {
//            return lockedLatestReading.value
//        }
//        set {
//            lockedLatestReading.value = newValue
//        }
//    }
//    private let lockedLatestReading: Locked<Glucose?> = Locked(nil)
    
    public var shouldSyncToRemoteService: Bool {
        return true
    }
    
    public var sensorState: SensorDisplayable? {
        return nil
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
//            "latestReading: \(String(describing: latestReading))",
            "providesBLEHeartbeat: \(providesBLEHeartbeat)",
            ""
            ].joined(separator: "\n")
    }
    
    
    public func fetchNewDataIfNeeded(_ completion: @escaping (LoopKit.CGMResult) -> Void) {
        completion(.noData)
        return
    }
}
