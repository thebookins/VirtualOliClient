//
//  VirtualOliClientPumpManager+UI.swift
//  VirtualOliClientUI
//
//  Created by Paul Dickens on 10/12/18.
//  Copyright © 2018 Paul Dickens. All rights reserved.
//

import Foundation
import LoopKit
import LoopKitUI
import VirtualOliClient


extension VirtualPumpManager: PumpManagerUI {
    public static func setupViewController() -> (UIViewController & CompletionNotifying & PumpManagerSetupViewController) {
        return VirtualPumpSetupViewController.instantiateFromStoryboard()
    }
    
    public func settingsViewController() -> (UIViewController & CompletionNotifying) {
        let settings = VirtualPumpSettingsViewController(pumpManager: self)
        let nav = SettingsNavigationViewController(rootViewController: settings)
        return nav
    }

    public var smallImage: UIImage? {
        return UIImage(named: "Simulator Small", in: Bundle(for: VirtualPumpSettingsViewController.self), compatibleWith: nil)
    }

    public func hudProvider() -> HUDProvider? {
        return nil
    }
    
    public static func createHUDViews(rawValue: [String : Any]) -> [BaseHUDView] {
        return []
    }
}

// MARK: - DeliveryLimitSettingsTableViewControllerSyncSource
extension VirtualPumpManager {
    public func syncDeliveryLimitSettings(for viewController: DeliveryLimitSettingsTableViewController, completion: @escaping (DeliveryLimitSettingsResult) -> Void) {
        completion(.success(maximumBasalRatePerHour: viewController.maximumBasalRatePerHour ?? 5.0, maximumBolus: viewController.maximumBolus ?? 25.0))
    }
    
    public func syncButtonTitle(for viewController: DeliveryLimitSettingsTableViewController) -> String {
        return "Save to pump"
    }
    
    public func syncButtonDetailText(for viewController: DeliveryLimitSettingsTableViewController) -> String? {
        return nil
    }
    
    public func deliveryLimitSettingsTableViewControllerIsReadOnly(_ viewController: DeliveryLimitSettingsTableViewController) -> Bool {
        return false
    }
}

// MARK: - BasalScheduleTableViewControllerSyncSource
extension VirtualPumpManager {
    public func syncScheduleValues(for viewController: BasalScheduleTableViewController, completion: @escaping (SyncBasalScheduleResult<Double>) -> Void) {
//        TODO: send basal schedule to the server
//        completion(.success(scheduleItems: viewController.scheduleItems, timeZone: .currentFixed))
    }
    
    public func syncButtonTitle(for viewController: BasalScheduleTableViewController) -> String {
        return "Save to pump"
    }
    
    public func syncButtonDetailText(for viewController: BasalScheduleTableViewController) -> String? {
        return nil
    }
    
    public func basalScheduleTableViewControllerIsReadOnly(_ viewController: BasalScheduleTableViewController) -> Bool {
        return false
    }
}
