////
////  VirtualOliClientPumpManager+UI.swift
////  VirtualOliClientUI
////
////  Created by Paul Dickens on 10/12/18.
////  Copyright © 2018 Paul Dickens. All rights reserved.
////
//
//import LoopKit
//import LoopKitUI
//import HealthKit
//import VirtualOliClient
//
//extension VirtualPumpManager: PumpManagerUI {
//    static public func setupViewController() -> (UIViewController & PumpManagerSetupViewController) {
//        return VirtualPumpSetupViewController()
//    }
//    
//    public func settingsViewController() -> UIViewController {
//        return VirtualPumpSettingsViewController()
//    }
//    
//    public func syncDeliveryLimitSettings(for viewController: DeliveryLimitSettingsTableViewController, completion: @escaping (DeliveryLimitSettingsResult) -> Void) {
//        completion(.success(maximumBasalRatePerHour: 5, maximumBolus: 5))
//    }
//    
//    public func syncButtonTitle(for viewController: DeliveryLimitSettingsTableViewController) -> String {
//        return LocalizedString("Save to Pump…", comment: "Title of button to save delivery limit settings to pump")
//    }
//    
//    public func syncButtonDetailText(for viewController: DeliveryLimitSettingsTableViewController) -> String? {
//        return nil
//    }
//    
//    public func deliveryLimitSettingsTableViewControllerIsReadOnly(_ viewController: DeliveryLimitSettingsTableViewController) -> Bool {
//        return true
//    }
//    
//    public func syncScheduleValues(for viewController: SingleValueScheduleTableViewController, completion: @escaping (RepeatingScheduleValueResult<Double>) -> Void) {
//        completion(.success(scheduleItems: [RepeatingScheduleValue<Double>(startTime: 0, value: 2.0)], timeZone: TimeZone.current))
//    }
//    
//    public func syncButtonTitle(for viewController: SingleValueScheduleTableViewController) -> String {
//        return LocalizedString("Save to Pump…", comment: "Title of button to save basal profile to pump")
//    }
//    
//    public func syncButtonDetailText(for viewController: SingleValueScheduleTableViewController) -> String? {
//        return nil
//    }
//    
//    public func singleValueScheduleTableViewControllerIsReadOnly(_ viewController: SingleValueScheduleTableViewController) -> Bool {
//        return true
//    }
//    
//    public var smallImage: UIImage? {
//        return nil
//    }
//}
