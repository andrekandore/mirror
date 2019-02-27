//
//  AppDelegate.swift
//  Mirror
//
//  Created by アンドレ on 2/24/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var mirrorCoordinator = MirrorCoordinator()
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let projector = self.window?.rootViewController as? ProjectorViewController {
            self.mirrorCoordinator.setup(with: projector)
        }

        return true
    }
    
}
