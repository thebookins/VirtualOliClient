////
////  VirtualOliClientPumpSetupViewController.swift
////  VirtualOliClientUI
////
////  Created by Paul Dickens on 10/12/18.
////  Copyright © 2018 Paul Dickens. All rights reserved.
////
//
//import LoopKit
//import LoopKitUI
//import VirtualOliClient
//
//class VirtualPumpSetupViewController: UINavigationController, PumpManagerSetupViewController {
//    var setupDelegate: PumpManagerSetupViewControllerDelegate?
//    
//    let pumpManager = VirtualPumpManager()
//    
//    var maxBasalRateUnitsPerHour: Double?
//    
//    var maxBolusUnits: Double?
//    
//    var basalSchedule: BasalRateSchedule?
//    
//    init() {
//        let authVC = AuthenticationViewController(authentication: pumpManager.shareService)
//        
//        super.init(rootViewController: authVC)
//        
//        authVC.authenticationObserver = { [weak self] (service) in
//            self?.pumpManager.shareService = service
//        }
//        authVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
//        authVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
//
//        title = "Virtual Pump" //cgmManager.localizedTitle
//    }
//        
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    @objc private func cancel() {
//        setupDelegate?.pumpManagerSetupViewControllerDidCancel(self)
//    }
//
//    @objc private func save() {
//        setupDelegate?.pumpManagerSetupViewController(self, didSetUpPumpManager: pumpManager)
//    }
//}
