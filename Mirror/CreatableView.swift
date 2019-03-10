//
//  CreatableView.swift
//  Mirror
//
//  Created by アンドレ on 3/9/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import UIKit

/*
 MARK: - Overridable Generic Initializers -
 */

/**
 Used for initializing an object from scratch either in
 subclass or in extension. This is used for when choosing
 an Object in a UI and then creating it from the list of
 classes presented.
 */
public protocol CreatableView: NSObjectProtocol {
    static func createNew() -> Self
}

extension UIView: CreatableView {
    @objc public class func createNew() -> Self {
        return self.init()
    }
}
