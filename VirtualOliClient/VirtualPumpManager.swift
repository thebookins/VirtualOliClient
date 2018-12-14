//
//  VirtualOliClientPumpManager.swift
//  VirtualOliClient
//
//  Created by Paul Dickens on 7/12/18.
//  Copyright © 2018 Paul Dickens. All rights reserved.
//

import HealthKit
import LoopKit


public class VirtualPumpManager : PumpManager {

    public static let managerIdentifier: String = "Virtual Pump"

    public var pumpManagerDelegate: PumpManagerDelegate?

    public var pumpBatteryChargeRemaining: Double? {
        return 0.5
    }

    public var pumpRecordsBasalProfileStartEvents: Bool {
        return true
    }

    public var pumpReservoirCapacity: Double {
        return 50
    }

    public var pumpTimeZone: TimeZone
    
    private let keychain = KeychainManager()
    
    public var shareService: ShareService {
        didSet {
            try! keychain.setDexcomShareUsername(shareService.username, password: shareService.password, url: shareService.url)
        }
    }

    
    public static let localizedTitle = LocalizedString("Virtual", comment: "Generic title of the simulated pump manager")

//    public var localizedTitle: String {
//        return String(format: LocalizedString("Minimed %@", comment: "Pump title (1: model number)"), state.pumpModel.rawValue)
//    }

    /// TODO: implement; see MinimedPumpManager for example
    private var isPumpDataStale: Bool {
        return true
    }
    
    // TODO: Isolate to queue
    private var lastAddedPumpEvents: Date = .distantPast


    /**
     Store a new reservoir volume and notify observers of new pump data.
     
     - parameter units:    The number of units remaining
     - parameter date:     The date the reservoir was read
     - parameter timeLeft: The approximate time before the reservoir is empty
     */
    private func updateReservoirVolume(_ units: Double, at date: Date, withTimeLeft timeLeft: TimeInterval?) {
        print("updating reservoir volume with \(units) units")
        pumpManagerDelegate?.pumpManager(self, didReadReservoirValue: units, at: date) { (result) in
            /// TODO: Isolate to queue
            
            switch result {
            case .failure:
                break
            case .success(let (_, _, areStoredValuesContinuous)):
                print("stored values continuous: \(areStoredValuesContinuous)")
                // Run a loop as long as we have fresh, reliable pump data.
//                if self.state.preferredInsulinDataSource == .pumpHistory || !areStoredValuesContinuous {
                    self.fetchPumpHistory { (error) in
                        if let error = error as? PumpManagerError {
                            self.pumpManagerDelegate?.pumpManager(self, didError: error)
                        }

                        if error == nil || areStoredValuesContinuous {
                            self.pumpManagerDelegate?.pumpManagerRecommendsLoop(self)
                        }
                    }
//                } else {
//                    self.pumpManagerDelegate?.pumpManagerRecommendsLoop(self)
//                }
            }
            
            // New reservoir data means we may want to adjust our timer tick requirements
            self.updateBLEHeartbeatPreference()
        }
    }

    /// TODO: Isolate to queue
    /// Polls the pump for new history events and passes them to the loop manager
    ///
    /// - Parameters:
    ///   - completion: A closure called once upon completion
    ///   - error: An error describing why the fetch and/or store failed
    private func fetchPumpHistory(_ completion: @escaping (_ error: Error?) -> Void) {
        guard let startDate = self.pumpManagerDelegate?.startDateToFilterNewPumpEvents(for: self) else {
            preconditionFailure("pumpManagerDelegate cannot be nil")
        }

        GlucoseFetcher.fetchHistoryEvents(since: startDate) { [weak self] events in
            guard let self = self else {
                return
            }
            self.pumpManagerDelegate?.pumpManager(self, didReadPumpEvents: events, completion: { (error) in
                if error == nil {
                    self.lastAddedPumpEvents = Date()
                }
                
                completion(error)
            })
        }
    }

    public func assertCurrentPumpData() {
        print("asserting pump data")

        guard isPumpDataStale else {
            return
        }
        
        // TODO: change the name from GlucoseFetcher to something more accurate
        GlucoseFetcher.fetchReservoir { [weak self] reservoir in
            guard let self = self else {
                return
            }
            self.updateReservoirVolume(reservoir, at: Date(), withTimeLeft: nil)
            
            let pumpManagerStatus = PumpManagerStatus(
                date: Date(), // TODO: this should really be pump date
                timeZone: TimeZone.current, // TODO: this should really be pump zone
                device: nil, // TODO: put real data in here
                lastValidFrequency: nil, // Minimed-specific ???
                lastTuned: nil, // again, Minimed-specific ???
                battery: nil, // TODO: update with battery model
                isSuspended: false, // TODO: update with status from API
                isBolusing: false, // TODO: update with status from API
                remainingReservoir: HKQuantity(unit: .internationalUnit(), doubleValue: reservoir)
            )
            
            self.pumpManagerDelegate?.pumpManager(self, didUpdateStatus: pumpManagerStatus)
        }
    }

    public func enactBolus(units: Double, at startDate: Date, willRequest: @escaping (Double, Date) -> Void, completion: @escaping (Error?) -> Void) {
        return
    }

    public func enactTempBasal(unitsPerHour: Double, for duration: TimeInterval, completion: @escaping (PumpManagerResult<DoseEntry>) -> Void) {
        // for now, just assume that it was successful
        let now = Date()
        let endDate = now.addingTimeInterval(30 * 60)
        let startDate = endDate.addingTimeInterval(-duration)
        completion(.success(DoseEntry(
            type: .tempBasal,
            startDate: startDate,
            endDate: endDate,
            value: unitsPerHour,
            unit: .unitsPerHour
        )))
        return
    }

    public func updateBLEHeartbeatPreference() {
    }

    public init() {
        // TODO: allow for different timezones
        self.pumpTimeZone = TimeZone.current
        shareService = ShareService(keychainManager: keychain)
    }
    
    required convenience public init?(rawState: PumpManager.RawStateValue) {
        self.init()
    }

    public var rawState: PumpManager.RawStateValue {
        return [:]
    }

    public var debugDescription: String {
        return ""
    }
}
