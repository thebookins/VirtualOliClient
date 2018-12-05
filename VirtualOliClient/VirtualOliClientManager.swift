//
//  VirtualOliClientManager.swift
//  VirtualOliClient
//
//  Created by Paul Dickens on 4/12/18.
//  Copyright © 2018 Paul Dickens. All rights reserved.
//

import HealthKit
import LoopKit
import SocketIO


public class VirtualOliClientManager : CGMManager {
    public static let managerIdentifier: String = "SimulatedCGM"

    // TODO: encapsulate all this in a class VirtualOliClient
    let manager = SocketManager(socketURL: URL(string: "https://virtual-oli.herokuapp.com/cgm")!, config: [.log(true), .compress])
    // end TODO

    public init() {
        shareService = ShareService(keychainManager: keychain)
        
        // TODO: encapsulate all this in a class VirtualOliClient
        let socket = manager.defaultSocket
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        socket.on("message") {data, ack in
            print(data[0])
//            guard let cur = data[0] as? Double else { return }
//
//            socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
//                socket.emit("update", ["amount": cur + 2.50])
//            }
//
//            ack.with("Got your currentAmount", "dude")
        }
        
        socket.connect()
        // end TODO
    }
    
    required convenience public init?(rawState: CGMManager.RawStateValue) {
        self.init()
    }
    
    public var rawState: CGMManager.RawStateValue {
        return [:]
    }
    
    private let keychain = KeychainManager()
    
    public var shareService: ShareService {
        didSet {
            try! keychain.setDexcomShareUsername(shareService.username, password: shareService.password, url: shareService.url)
        }
    }
    
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
