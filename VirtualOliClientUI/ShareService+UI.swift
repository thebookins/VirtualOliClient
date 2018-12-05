//
//  ShareService+UI.swift
//  Loop
//
//  Copyright © 2018 LoopKit Authors. All rights reserved.
//

import LoopKitUI
import VirtualOliClient


extension ShareService: ServiceAuthenticationUI {
    public var credentialFormFields: [ServiceCredential] {
        return [
            ServiceCredential(
                title: LocalizedString("Username", comment: "The title of the Dexcom share username credential"),
                isSecret: false,
                keyboardType: .asciiCapable
            ),
            ServiceCredential(
                title: LocalizedString("Password", comment: "The title of the Dexcom share password credential"),
                isSecret: true,
                keyboardType: .asciiCapable
            ),
            ServiceCredential(
                title: LocalizedString("Server", comment: "The title of the Dexcom share server URL credential"),
                isSecret: false,
                options: [
                    (title: LocalizedString("US", comment: "U.S. share server option title"),
                     value: "https://virtual-oli.herokuapp.com"),
//                    (title: LocalizedString("Outside US", comment: "Outside US share server option title"),
//                     value: KnownShareServers.NON_US.rawValue)
                    
                ]
            )
        ]
    }
}
