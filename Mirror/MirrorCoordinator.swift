//
//  MirrorCoordinator.swift
//  Mirror
//
//  Created by アンドレ on 2/27/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import UIKit

/**
 Coordinate New Windows Appearing and Piping Images from Projector to the Mirror
 */
class MirrorCoordinator {
    
    var additionalWindows: [UIWindow] = []
    
    var mirrorViewController: MirrorViewController? {
        didSet {
            self.mirrorViewController?.image = currentImage
        }
    }
    
    var currentImage: UIImage? {
        didSet {
            self.mirrorViewController?.image = currentImage
        }
    }
    
    func setup(with projector: ProjectorViewController) {
        
        projector.mirrorCoordinator = self
        
        NotificationCenter.default.addObserver(forName: UIScreen.didConnectNotification, object: nil, queue: nil, using: screenDidConnect)
        
        NotificationCenter.default.addObserver(forName: UIScreen.didDisconnectNotification, object: nil, queue: nil, using: screenDidDisconnect)
    }
    
    func screenDidConnect(notification: Notification) {
        
        // Get the new screen information.
        let newScreen = notification.object as! UIScreen
        let screenDimensions = newScreen.bounds
        
        // Configure a window for the screen.
        let newWindow = UIWindow(frame: screenDimensions)
        newWindow.screen = newScreen
        
        // Install a custom root view controller in the window.
        if let viewController = UIStoryboard.init(name: "Mirror", bundle: nil)
            .instantiateInitialViewController() as? MirrorViewController {
            newWindow.rootViewController = viewController
            self.mirrorViewController = viewController
        }
        
        // You must show the window explicitly.
        newWindow.isHidden = false
        
        // Save a reference to the window in a local array.
        self.additionalWindows.append(newWindow)
    }
    
    func screenDidDisconnect(notification: Notification) {
        
        let screen = notification.object as! UIScreen
        
        // Remove the window associated with the screen.
        for window in self.additionalWindows {
            if window.screen == screen {
                
                // Remove the window and its contents.
                let index = self.additionalWindows.index(of: window)
                self.additionalWindows.remove(at: index!)
            }
        }
    }
}
