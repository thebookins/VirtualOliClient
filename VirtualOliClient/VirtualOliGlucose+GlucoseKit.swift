//
//  VirtualOliGlucose+GlucoseKit.swift
//  VirtualOliClient
//
//  Created by Paul Dickens on 7/12/18.
//  Copyright © 2018 Paul Dickens. All rights reserved.
//

import Foundation
import HealthKit
import LoopKit


extension VirtualOliGlucose: GlucoseValue {
    public var startDate: Date {
        return readDate
    }
    
    public var quantity: HKQuantity {
        return HKQuantity(unit: .milligramsPerDeciliter, doubleValue: Double(18 * glucose))
    }
}


extension VirtualOliGlucose: SensorDisplayable {
    public var isStateValid: Bool {
        return glucose >= 2.2
    }
    
    public var trendType: GlucoseTrend? {
        return nil
//        return GlucoseTrend(rawValue: Int(trend))
    }
    
    public var isLocal: Bool {
        return false
    }
}

extension SensorDisplayable {
    public var stateDescription: String {
        if isStateValid {
            return LocalizedString("OK", comment: "Sensor state description for the valid state")
        } else {
            return LocalizedString("Needs Attention", comment: "Sensor state description for the non-valid state")
        }
    }
}
