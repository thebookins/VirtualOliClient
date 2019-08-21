//
//  MockPumpManagerSetupViewController.swift
//  LoopKitUI
//
//  Created by Michael Pangburn on 11/20/18.
//  Copyright © 2018 LoopKit Authors. All rights reserved.
//
import UIKit
import LoopKit
import LoopKitUI
import VirtualOliClient


final class VirtualPumpSetupViewController: UINavigationController, PumpManagerSetupViewController, CompletionNotifying {
    
    static func instantiateFromStoryboard() -> VirtualPumpSetupViewController {
        return UIStoryboard(name: "VirtualPumpManager", bundle: Bundle(for: VirtualPumpSetupViewController.self)).instantiateInitialViewController() as! VirtualPumpSetupViewController
    }
    
    var maxBasalRateUnitsPerHour: Double?
    
    var maxBolusUnits: Double?
    
    var basalSchedule: BasalRateSchedule?
    
    let pumpManager = VirtualPumpManager()
    
    weak var setupDelegate: PumpManagerSetupViewControllerDelegate?
    
    weak var completionDelegate: CompletionDelegate?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationBar.shadowImage = UIImage()
        
        delegate = self
    }
    
    func completeSetup() {
        setupDelegate?.pumpManagerSetupViewController(self, didSetUpPumpManager: pumpManager)
        completionDelegate?.completionNotifyingDidComplete(self)
    }
    
    public func finishedSettingsDisplay() {
        completionDelegate?.completionNotifyingDidComplete(self)
    }
}

extension VirtualPumpSetupViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        switch viewController {
        case let vc as VirtualPumpSettingsSetupViewController:
            vc.pumpManager = pumpManager
        default:
            break
        }
        
        // Adjust the appearance for the main setup view controllers only
        if let setupViewController = viewController as? SetupTableViewController {
            setupViewController.delegate = self
            navigationBar.isTranslucent = false
            navigationBar.shadowImage = UIImage()
        } else {
            navigationBar.isTranslucent = true
            navigationBar.shadowImage = nil
        }
    }
}

extension VirtualPumpSetupViewController: SetupTableViewControllerDelegate {
    public func setupTableViewControllerCancelButtonPressed(_ viewController: SetupTableViewController) {
        completionDelegate?.completionNotifyingDidComplete(self)
    }
}
