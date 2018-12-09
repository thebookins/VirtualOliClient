//
//  GlucoseFetcher.swift
//  VirtualOliClient
//
//  Created by Paul Dickens on 9/12/18.
//  Copyright © 2018 Paul Dickens. All rights reserved.
//

import UIKit

struct GlucoseFetcher {
    static let glucoseURL = "https://virtual-oli.herokuapp.com/api/glucose"
    
    static func fetchGlucose(_ completion: @escaping (VirtualOliGlucose) -> Void) {
        guard let url = URL(string: glucoseURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            print("got data \(data)")
            
            guard let decoded = try? JSONSerialization.jsonObject(with: data) else {
//                completion
                return
            }
            print("got decoded data \(decoded)")
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

            guard let glucoseResponse = decoded as? [String: Any], let glucoseValue = glucoseResponse["glucose"] as? Double, let readDate = dateFormatter.date(from: glucoseResponse["readDate"] as! String) else {
//                completion
                return
            }
            print("got glucose values")
            
            let glucose = VirtualOliGlucose(glucose: glucoseValue, readDate: readDate)
            print("created glucose struct")

            completion(glucose)
        }
        
        task.resume()
    }
}
