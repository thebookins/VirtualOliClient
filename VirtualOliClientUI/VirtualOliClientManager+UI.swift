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

extension VirtualOliClientManager: CGMManagerUI {
    public static func setupViewController() -> (UIViewController & CGMManagerSetupViewController)? {
        return nil
    }
    
    public func settingsViewController(for glucoseUnit: HKUnit) -> UIViewController {
        return VirtualOliClientSettingsViewController()
    }
    
    public var smallImage: UIImage? {
        return nil
    }
}
