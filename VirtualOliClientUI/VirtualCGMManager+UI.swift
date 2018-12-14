//
//  VirtualOliClientManager+UI.swift
//  VirtualOliClientUI
//
//  Created by Paul Dickens on 4/12/18.
//  Copyright © 2018 thebookins. All rights reserved.
//

import LoopKitUI
import HealthKit
import VirtualOliClient

extension VirtualCGMManager: CGMManagerUI {
    public static func setupViewController() -> (UIViewController & CGMManagerSetupViewController)? {
        print("about to return setup view controller")
        return VirtualCGMSetupViewController()
    }
    
    public func settingsViewController(for glucoseUnit: HKUnit) -> UIViewController {
        return VirtualCGMSettingsViewController(cgmManager: self, allowsDeletion: true)
    }
    
    public var smallImage: UIImage? {
        return nil
    }
}
