//
//  GlucoseFetcher.swift
//  VirtualOliClient
//
//  Created by Paul Dickens on 9/12/18.
//  Copyright © 2018 Paul Dickens. All rights reserved.
//

import UIKit
import LoopKit

struct GlucoseFetcher {
//    static let glucoseURL = "https://virtual-oli.herokuapp.com/api/cgm"
    static let glucoseURL = "http://localhost:5000/api/cgms/5d42cc46e7179a064fabed43"
    static let statusURL = "https://virtual-oli.herokuapp.com/api/pump/status"
    static let pumpURL = "https://virtual-oli.herokuapp.com/api/pump"

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    
    static func fetchGlucose(_ completion: @escaping (Glucose) -> Void) {
        guard let url = URL(string: glucoseURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
//                TODO: call completion handler here
                return
            }
            
            guard let decoded = try? JSONSerialization.jsonObject(with: data) else {
//                TODO: call completion handler here
                return
            }
            
            guard let glucoseResponse = decoded as? [String: Any], let glucoseValue = glucoseResponse["glucose"] as? Double, let readDate = dateFormatter.date(from: glucoseResponse["readDate"] as! String) else {
//                TODO: call completion handler here
                return
            }
            
            let glucose = Glucose(glucose: glucoseValue, readDate: readDate)

            completion(glucose)
        }
        
        task.resume()
    }
    
    // TODO: make this something like "fetchStatus"
    static func fetchReservoir(_ completion: @escaping (Double) -> Void) {
        guard let url = URL(string: statusURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            guard let decoded = try? JSONSerialization.jsonObject(with: data) else {
                //                TODO: call completion handler here
                return
            }
            
            guard let statusResponse = decoded as? [String: Any], let reservoirValue = statusResponse["reservoir"] as? Double else {
                //                TODO: call completion handler here
                return
            }
            
            completion(reservoirValue)
        }
        
        task.resume()
    }
    
    // TODO: call out to the real history endpoint
    static func fetchHistoryEvents(since startDate: Date, _ completion: @escaping ([NewPumpEvent]) -> Void) {
        guard let url = URL(string: pumpURL) else { return }
        var history = [NewPumpEvent]()

        // TODO: query using startDate
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }

            guard let decoded = try? JSONSerialization.jsonObject(with: data) else {
                //                TODO: call completion handler here
                return
            }

            guard let historyResponse = decoded as? [[String: Any]] else {
                //                TODO: call completion handler here
                return
            }

            for eventRaw in historyResponse {
                // TODO: datestamp is a stupid name
                guard let date = dateFormatter.date(from: eventRaw["datestamp"] as! String), let type = eventRaw["type"] as? String else {
                    //                TODO: call completion handler here
                    return
                }

                var rawData = Int(date.timeIntervalSince1970 * 1000)

                switch type {
                case "bolus":
                    guard let dose = eventRaw["dose"] as? Double else {
                        // TODO call completion handler here
                        return
                    }
                    let doseEntry = DoseEntry(type: .bolus, startDate: date, value: dose, unit: .units)
                    var rawData = Int(date.timeIntervalSince1970 * 1000)

                    let event = NewPumpEvent(date: date, dose: doseEntry, isMutable: false, raw: Data(bytes: &rawData, count: MemoryLayout.size(ofValue: rawData)), title: "Bolus")
                    history.insert(event, at: 0)
                    break
                case "temp basal":
                    print("processing temp basal")
                    guard let rate = eventRaw["rate"] as? Double, let duration = eventRaw["duration"] as? Double else {
                        // TODO call completion handler here
                        return
                    }
                    let dose = DoseEntry(
                        type: .tempBasal,
                        startDate: date,
                        endDate: date.addingTimeInterval(TimeInterval(minutes: duration)),
                        value: rate,
                        unit: .unitsPerHour
                    )
                    let event = NewPumpEvent(
                        date: date,
                        dose: dose,
                        isMutable: false,
                        raw: Data(bytes: &rawData, count: MemoryLayout.size(ofValue: rawData)),
                        title: String(format: "Temp Basal: %.1f U/hr", rate),
                        type: .tempBasal
                    )

                    print("about to insert temp basal")
                    history.insert(event, at: 0)
                    break

                default: break
                }
            }
            completion(history)
        }
        task.resume()
    }

    static func postBolus(units: Double, _ completion: @escaping () -> Void) {
        guard let url = URL(string: pumpURL) else { return }

        let bolusDetails = ["type" : "bolus", "dose" : units] as [String : Any]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: bolusDetails, options: []) else {
            return
        }
        request.httpBody = httpBody

        let task = URLSession.shared.dataTask(with: request) { _, _, _ in
            completion()
        }
        task.resume()
    }

    static func postTempBasal(rate: Double, duration: TimeInterval, _ completion: @escaping () -> Void) {
        guard let url = URL(string: pumpURL) else { return }

        let details = ["type": "setTempBasal", "dose": rate, "duration": duration.minutes] as [String : Any]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: details, options: []) else {
            return
        }
        request.httpBody = httpBody

        let task = URLSession.shared.dataTask(with: request) { _, _, _ in
            completion()
        }
        task.resume()
    }
}
