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
    public static func setupViewController() -> (UIViewController & CGMManagerSetupViewController & CompletionNotifying)? {
//        let setup = VirtualCGMSetupViewController()
//        let nav = SetupNavigationViewController(rootViewController: setup)
//        return nav
        return nil
    }
    
    public func settingsViewController(for glucoseUnit: HKUnit) -> UIViewController & CompletionNotifying {
        let settings = VirtualCGMSettingsViewController(cgmManager: self, allowsDeletion: true)
        let nav = SettingsNavigationViewController(rootViewController: settings)
        return nav
    }
    
    public var smallImage: UIImage? {
        return nil
    }
}
