//
//  VirtualPumpSettingsViewController.swift
//  VirtualOliClientUI
//
//  Created by Paul Dickens on 10/12/18.
//  Copyright © 2018 Paul Dickens. All rights reserved.
//

import UIKit
import LoopKit
import LoopKitUI
import VirtualOliClient

class VirtualPumpSettingsViewController: UITableViewController {
    
    let pumpManager: VirtualPumpManager
    
    init(pumpManager: VirtualPumpManager) {
        self.pumpManager = pumpManager
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    
//    public let cgmManager: VirtualOliClientCGMManager
//    
//    public let allowsDeletion: Bool
//    
//    public init(cgmManager: VirtualOliClientCGMManager, allowsDeletion: Bool) {
//        self.cgmManager = cgmManager
//        self.allowsDeletion = allowsDeletion
//        
//        super.init(style: .grouped)
//    }
//    
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pump Settings"
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 55
        
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.className)
        tableView.register(TextButtonTableViewCell.self, forCellReuseIdentifier: TextButtonTableViewCell.className)
        
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped(_:)))
        self.navigationItem.setRightBarButton(button, animated: false)
    }
    
    @objc func doneTapped(_ sender: Any) {
        done()
    }
    
    private func done() {
        if let nav = navigationController as? SettingsNavigationViewController {
            nav.notifyComplete()
        }
        if let nav = navigationController as? VirtualPumpSetupViewController {
            nav.finishedSettingsDisplay()
        }
    }
//
//    // MARK: - Table view data source
//    
    private enum Section: Int, CaseIterable {
        //        case authentication
        //        case latestReading
        case delete = 0
        
        static let count = 1 //3
    }

    override public func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
//
//    //    private enum LatestReadingRow: Int {
//    //        case glucose
//    //        case date
//    //        case trend
//    //
//    //        static let count = 3
//    //    }
//    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
            //        case .authentication:
            //            return 1
            //        case .latestReading:
        //            return LatestReadingRow.count
        case .delete:
            return 1
        }
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
            //        case .authentication:
            //            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.className, for: indexPath) as! SettingsTableViewCell
            //
            //            let service = cgmManager.shareService
            //
            //            cell.textLabel?.text = LocalizedString("Credentials", comment: "Title of cell to set credentials")
            //            cell.detailTextLabel?.text = service.username ?? SettingsTableViewCell.TapToSetString
            //            cell.accessoryType = .disclosureIndicator
            //
            //            return cell
            //        case .latestReading:
            //            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.className, for: indexPath) as! SettingsTableViewCell
            //            let glucose = cgmManager.latestBackfill
            //
            //            switch LatestReadingRow(rawValue: indexPath.row)! {
            //            case .glucose:
            //                cell.textLabel?.text = LocalizedString("Glucose", comment: "Title describing glucose value")
            //
            //                if let quantity = glucose?.quantity, let formatted = glucoseFormatter.string(from: quantity, for: glucoseUnit) {
            //                    cell.detailTextLabel?.text = formatted
            //                } else {
            //                    cell.detailTextLabel?.text = SettingsTableViewCell.NoValueString
            //                }
            //            case .date:
            //                cell.textLabel?.text = LocalizedString("Date", comment: "Title describing glucose date")
            //
            //                if let date = glucose?.timestamp {
            //                    cell.detailTextLabel?.text = dateFormatter.string(from: date)
            //                } else {
            //                    cell.detailTextLabel?.text = SettingsTableViewCell.NoValueString
            //                }
            //            case .trend:
            //                cell.textLabel?.text = LocalizedString("Trend", comment: "Title describing glucose trend")
            //
            //                cell.detailTextLabel?.text = glucose?.trendType?.localizedDescription ?? SettingsTableViewCell.NoValueString
            //            }
            //
        //            return cell
        case .delete:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextButtonTableViewCell.className, for: indexPath) as! TextButtonTableViewCell
            
            cell.textLabel?.text = LocalizedString("Delete Pump", comment: "Title text for the button to remove a Pump from Loop")
            cell.textLabel?.textAlignment = .center
            cell.tintColor = .delete
            cell.isEnabled = true
            return cell
        }
    }
//
//    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch Section(rawValue: section)! {
//            //        case .authentication:
//            //            return nil
//            //        case .latestReading:
//        //            return LocalizedString("Latest Reading", comment: "Section title for latest glucose reading")
//        case .delete:
//            return nil
//        }
//    }
//    
//    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch Section(rawValue: indexPath.section)! {
//            //        case .authentication:
//            //            let vc = AuthenticationViewController(authentication: cgmManager.shareService)
//            //            vc.authenticationObserver = { [weak self] (service) in
//            //                self?.cgmManager.shareService = service
//            //
//            //                self?.tableView.reloadRows(at: [indexPath], with: .none)
//            //            }
//            //
//            //            show(vc, sender: nil)
//            //        case .latestReading:
//        //            tableView.deselectRow(at: indexPath, animated: true)
//        case .delete:
//            let confirmVC = UIAlertController(cgmDeletionHandler: {
//                self.cgmManager.cgmManagerDelegate?.cgmManagerWantsDeletion(self.cgmManager)
//                self.navigationController?.popViewController(animated: true)
//            })
//            
//            present(confirmVC, animated: true) {
//                tableView.deselectRow(at: indexPath, animated: true)
//            }
//        }
//    }
}

private extension UIAlertController {
    convenience init(pumpDeletionHandler handler: @escaping () -> Void) {
        self.init(
            title: nil,
            message: "Are you sure you want to delete this pump?",
            preferredStyle: .actionSheet
        )
        
        addAction(UIAlertAction(
            title: "Delete Pump",
            style: .destructive,
            handler: { _ in handler() }
        ))
        
        addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
}
