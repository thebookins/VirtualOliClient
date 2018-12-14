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
    static let glucoseURL = "https://virtual-oli.herokuapp.com/api/cgm"
    static let statusURL = "https://virtual-oli.herokuapp.com/api/pump/status"
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    
    static func fetchGlucose(_ completion: @escaping (Glucose) -> Void) {
        guard let url = URL(string: glucoseURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
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
        let history = [NewPumpEvent]()
        completion(history)
    }
}
