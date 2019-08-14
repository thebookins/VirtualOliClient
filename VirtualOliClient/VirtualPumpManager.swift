//
//  VirtualOliClientPumpManager.swift
//  VirtualOliClient
//
//  Created by Paul Dickens on 7/12/18.
//  Copyright © 2018 Paul Dickens. All rights reserved.
//

import HealthKit
import LoopKit


//public class VirtualPumpManager : PumpManager {
//    public var supportedBasalRates: [Double]
//
//    public var supportedBolusVolumes: [Double]
//
//    public var maximumBasalScheduleEntryCount: Int
//
//    public var minimumBasalScheduleEntryDuration: TimeInterval
//
//    public var status: PumpManagerStatus
//
//    public func addStatusObserver(_ observer: PumpManagerStatusObserver, queue: DispatchQueue) {
//        // TODO: implement
//    }
//
//    public func removeStatusObserver(_ observer: PumpManagerStatusObserver) {
//        // TODO: implement
//    }
//
//    public func setMustProvideBLEHeartbeat(_ mustProvideBLEHeartbeat: Bool) {
//        // TODO: implement
//    }
//
//    public func createBolusProgressReporter(reportingOn dispatchQueue: DispatchQueue) -> DoseProgressReporter? {
//        <#code#>
//    }
//
//    public func enactBolus(units: Double, at startDate: Date, willRequest: @escaping (DoseEntry) -> Void, completion: @escaping (PumpManagerResult<DoseEntry>) -> Void) {
//        <#code#>
//    }
//
//    public func cancelBolus(completion: @escaping (PumpManagerResult<DoseEntry?>) -> Void) {
//        <#code#>
//    }
//
//    public func suspendDelivery(completion: @escaping (Error?) -> Void) {
//        <#code#>
//    }
//
//    public func resumeDelivery(completion: @escaping (Error?) -> Void) {
//
//    }
//
//    public var delegateQueue: DispatchQueue!
//
//
//    public static let managerIdentifier: String = "Virtual Pump"
//
//    public var pumpManagerDelegate: PumpManagerDelegate?
//
//    public var pumpBatteryChargeRemaining: Double? {
//        return 0.5
//    }
//
//    public var pumpRecordsBasalProfileStartEvents: Bool {
//        return true
//    }
//
//    public var pumpReservoirCapacity: Double = 300
//
//    public var pumpTimeZone: TimeZone
//
//    private let keychain = KeychainManager()
//
//    public var shareService: ShareService {
//        didSet {
//            try! keychain.setDexcomShareUsername(shareService.username, password: shareService.password, url: shareService.url)
//        }
//    }
//
//
//    public static let localizedTitle = LocalizedString("Virtual", comment: "Generic title of the simulated pump manager")
//
////    public var localizedTitle: String {
////        return String(format: LocalizedString("Minimed %@", comment: "Pump title (1: model number)"), state.pumpModel.rawValue)
////    }
//
//    /// TODO: implement; see MinimedPumpManager for example
//    private var isPumpDataStale: Bool {
//        return true
//    }
//
//    // TODO: Isolate to queue
//    private var lastAddedPumpEvents: Date = .distantPast
//
//
//    /**
//     Store a new reservoir volume and notify observers of new pump data.
//
//     - parameter units:    The number of units remaining
//     - parameter date:     The date the reservoir was read
//     - parameter timeLeft: The approximate time before the reservoir is empty
//     */
//    private func updateReservoirVolume(_ units: Double, at date: Date, withTimeLeft timeLeft: TimeInterval?) {
//        print("updating reservoir volume with \(units) units")
//        pumpManagerDelegate?.pumpManager(self, didReadReservoirValue: units, at: date) { (result) in
//            /// TODO: Isolate to queue
//
//            switch result {
//            case .failure:
//                break
//            case .success(let (_, _, areStoredValuesContinuous)):
//                print("stored values continuous: \(areStoredValuesContinuous)")
//                // Run a loop as long as we have fresh, reliable pump data.
////                if self.state.preferredInsulinDataSource == .pumpHistory || !areStoredValuesContinuous {
//                    self.fetchPumpHistory { (error) in
//                        if let error = error as? PumpManagerError {
//                            self.pumpManagerDelegate?.pumpManager(self, didError: error)
//                        }
//
//                        if error == nil || areStoredValuesContinuous {
//                            self.pumpManagerDelegate?.pumpManagerRecommendsLoop(self)
//                        }
//                    }
////                } else {
////                    self.pumpManagerDelegate?.pumpManagerRecommendsLoop(self)
////                }
//            }
//
//            // New reservoir data means we may want to adjust our timer tick requirements
//            self.updateBLEHeartbeatPreference()
//        }
//    }
//
//    /// TODO: Isolate to queue
//    /// Polls the pump for new history events and passes them to the loop manager
//    ///
//    /// - Parameters:
//    ///   - completion: A closure called once upon completion
//    ///   - error: An error describing why the fetch and/or store failed
//    private func fetchPumpHistory(_ completion: @escaping (_ error: Error?) -> Void) {
//        guard let startDate = self.pumpManagerDelegate?.startDateToFilterNewPumpEvents(for: self) else {
//            preconditionFailure("pumpManagerDelegate cannot be nil")
//        }
//
//        GlucoseFetcher.fetchHistoryEvents(since: startDate) { [weak self] events in
//            guard let self = self else {
//                return
//            }
//            self.pumpManagerDelegate?.pumpManager(self, didReadPumpEvents: events, completion: { (error) in
//                if error == nil {
//                    self.lastAddedPumpEvents = Date()
//                }
//
//                completion(error)
//            })
//        }
//    }
//
//    private func isReservoirDataOlderThan(timeIntervalSinceNow: TimeInterval) -> Bool {
//        var lastReservoirDate = pumpManagerDelegate?.startDateToFilterNewReservoirEvents(for: self) ?? .distantPast
//        return lastReservoirDate.timeIntervalSinceNow <= timeIntervalSinceNow
//    }
//
//    public func assertCurrentPumpData() {
//        print("asserting pump data")
//
//        guard isPumpDataStale else {
//            return
//        }
//
//        // TODO: change the name from GlucoseFetcher to something more accurate
//        GlucoseFetcher.fetchReservoir { [weak self] reservoir in
//            guard let self = self else {
//                return
//            }
//            self.updateReservoirVolume(reservoir, at: Date(), withTimeLeft: nil)
//
//            let pumpManagerStatus = PumpManagerStatus(
//                date: Date(), // TODO: this should really be pump date
//                timeZone: TimeZone.current, // TODO: this should really be pump zone
//                device: nil, // TODO: put real data in here
//                lastValidFrequency: nil, // Minimed-specific ???
//                lastTuned: nil, // again, Minimed-specific ???
//                battery: nil, // TODO: update with battery model
//                isSuspended: false, // TODO: update with status from API
//                isBolusing: false, // TODO: update with status from API
//                remainingReservoir: HKQuantity(unit: .internationalUnit(), doubleValue: reservoir)
//            )
//
//            self.pumpManagerDelegate?.pumpManager(self, didUpdateStatus: pumpManagerStatus)
//        }
//    }
//
//    public func enactBolus(units: Double, at startDate: Date, willRequest: @escaping (Double, Date) -> Void, completion: @escaping (Error?) -> Void) {
//        guard units > 0 else {
//            completion(nil)
//            return
//        }
//
//        // If we don't have recent pump data, or the pump was recently rewound, read new pump data before bolusing.
//        let shouldReadReservoir = isReservoirDataOlderThan(timeIntervalSinceNow: .minutes(-6))
//
//        if shouldReadReservoir {
//            GlucoseFetcher.fetchReservoir { [weak self] reservoir in
//                guard let self = self else {
//                    return
//                }
//                self.pumpManagerDelegate?.pumpManager(self, didReadReservoirValue: reservoir, at: Date()) { _ in
//                    // Ignore result
//                }
//            }
//        }
//
//        willRequest(1.0, Date())
//
//        // TODO: handle error cases in callback
//        GlucoseFetcher.postBolus(units: 1) { () -> Void in
//            completion(nil)
//        }
//    }
//
//    public func enactTempBasal(unitsPerHour: Double, for duration: TimeInterval, completion: @escaping (PumpManagerResult<DoseEntry>) -> Void) {
//
//        // TODO: handle error cases in callback
//        GlucoseFetcher.postTempBasal(rate: unitsPerHour, duration: duration) { () -> Void in
//            // for now, just assume that it was successful
//            let now = Date()
//            let endDate = now.addingTimeInterval(30 * 60) // TODO: this should be derived from a http response
//            let startDate = endDate.addingTimeInterval(-duration) // TODO: as should this
//            completion(.success(DoseEntry(
//                type: .tempBasal,
//                startDate: startDate,
//                endDate: endDate,
//                value: unitsPerHour,
//                unit: .unitsPerHour
//            )))
//            return
//        }
//    }
//
//    public func updateBLEHeartbeatPreference() {
//    }
//
//    public init() {
//        // TODO: allow for different timezones
//        self.pumpTimeZone = TimeZone.current
//        shareService = ShareService(keychainManager: keychain)
//    }
//
//    required convenience public init?(rawState: PumpManager.RawStateValue) {
//        self.init()
//    }
//
//    public var rawState: PumpManager.RawStateValue {
//        return [:]
//    }
//
//    public var debugDescription: String {
//        return ""
//    }
//}
