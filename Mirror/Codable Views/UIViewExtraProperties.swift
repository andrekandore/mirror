//
//  UIViewExtraProperties.swift
//  Mirror
//
//  Created by アンドレ on 3/10/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import UIKit

extension UIView {
    struct AdditionalBasicProperties: Equatable, Codable, ComparisonKeyPathApplying {
        var semanticContentAttribute: UISemanticContentAttribute?
        var insetsLayoutMarginsFromSafeArea: Bool?
        var preservesSuperviewLayoutMargins: Bool?
        var autoresizingMask: AutoresizingMask?
        var isUserInteractionEnabled: Bool?
        var transform: UIAffineTransform?
        var isMultipleTouchEnabled: Bool?
        var layoutMargins: UIEdgeInsets?
        var contentScaleFactor: CGFloat?
        var autoresizesSubviews: Bool?
        var isExclusiveTouch: Bool?
        var clipsToBounds: Bool?
        var tag: Int?
    }
}

extension UISemanticContentAttribute: Codable {}
extension UIView.AutoresizingMask: Codable {}

extension UIView.AdditionalBasicProperties {
    
    init?(from view: UIView) {
        self.init()
        
        self = self.default
        
        typealias This = UIView.AdditionalBasicProperties
        
        let paths = [
            (destination: \This.insetsLayoutMarginsFromSafeArea, origin: \UIView.insetsLayoutMarginsFromSafeArea),
            (destination: \This.preservesSuperviewLayoutMargins, origin: \UIView.preservesSuperviewLayoutMargins),
            (destination: \This.isUserInteractionEnabled, origin: \UIView.isUserInteractionEnabled),
            (destination: \This.isMultipleTouchEnabled, origin: \UIView.isMultipleTouchEnabled),
            (destination: \This.autoresizesSubviews, origin: \UIView.autoresizesSubviews),
            (destination: \This.isExclusiveTouch, origin: \UIView.isExclusiveTouch),
            (destination: \This.clipsToBounds, origin: \UIView.clipsToBounds),
        ]
        
        var wasDifferentComparedToDefault = false
        for path in paths {
            wasDifferentComparedToDefault |= self.applyKeyPath(path.destination, from: view, using: path.origin, if: !=)
        }

        wasDifferentComparedToDefault |= self.applyKeyPath(\This.transform, from: view, using: \UIView.transform, if: !=, transforming: { $0.asCustomEncodable })
        wasDifferentComparedToDefault |= self.applyKeyPath(\This.semanticContentAttribute, from: view, using: \UIView.semanticContentAttribute, if: !=)
        wasDifferentComparedToDefault |= self.applyKeyPath(\This.contentScaleFactor, from: view, using: \UIView.contentScaleFactor, if: !=)
        wasDifferentComparedToDefault |= self.applyKeyPath(\This.autoresizingMask, from: view, using: \UIView.autoresizingMask, if: !=)
        wasDifferentComparedToDefault |= self.applyKeyPath(\This.layoutMargins, from: view, using: \UIView.layoutMargins, if: !=)
        wasDifferentComparedToDefault |= self.applyKeyPath(\This.tag, from: view, using: \UIView.tag, if: !=)
        
        guard wasDifferentComparedToDefault else {
            return nil
        }
    }
}

extension UIView.AdditionalBasicProperties {
    func apply(to view: UIView) {
        let defs = self.default
        self.insetsLayoutMarginsFromSafeArea.do(comparingTo: defs.insetsLayoutMarginsFromSafeArea) { view.insetsLayoutMarginsFromSafeArea = $0 }
        self.preservesSuperviewLayoutMargins.do(comparingTo: defs.preservesSuperviewLayoutMargins) { view.preservesSuperviewLayoutMargins = $0 }
        self.isUserInteractionEnabled.do(comparingTo: defs.isUserInteractionEnabled) { view.isUserInteractionEnabled = $0 }
        self.semanticContentAttribute.do(comparingTo: defs.semanticContentAttribute) { view.semanticContentAttribute = $0 }
        self.isMultipleTouchEnabled.do(comparingTo: defs.isMultipleTouchEnabled) { view.isMultipleTouchEnabled = $0 }
        self.autoresizesSubviews.do(comparingTo: defs.autoresizesSubviews) { view.autoresizesSubviews = $0 }
        self.contentScaleFactor.do(comparingTo: defs.contentScaleFactor) { view.contentScaleFactor = $0 }
        self.isExclusiveTouch.do(comparingTo: defs.isExclusiveTouch) { view.isExclusiveTouch = $0 }
        self.autoresizingMask.do(comparingTo: defs.autoresizingMask) { view.autoresizingMask = $0 }
        self.clipsToBounds.do(comparingTo: defs.clipsToBounds) { view.clipsToBounds = $0 }
        self.layoutMargins.do(comparingTo: defs.layoutMargins) { view.layoutMargins = $0 }
        self.transform.do(comparingTo: defs.transform) { view.transform = $0.wrapped }
        self.tag.do(comparingTo: defs.tag) { view.tag = $0 }
    }
}

extension UIView.AdditionalBasicProperties {
    static var `default`: UIView.AdditionalBasicProperties { return _defaultValues }
    var `default`: UIView.AdditionalBasicProperties { return UIView.AdditionalBasicProperties.default }
}

private let _defaultValues: UIView.AdditionalBasicProperties = {
    
    var defaultValues = UIView.AdditionalBasicProperties.init()
    let defaultView = UIView()
    
    defaultValues.insetsLayoutMarginsFromSafeArea = defaultView.insetsLayoutMarginsFromSafeArea
    defaultValues.preservesSuperviewLayoutMargins = defaultView.preservesSuperviewLayoutMargins
    defaultValues.isUserInteractionEnabled = defaultView.isUserInteractionEnabled
    defaultValues.semanticContentAttribute = defaultView.semanticContentAttribute
    defaultValues.isMultipleTouchEnabled = defaultView.isMultipleTouchEnabled
    defaultValues.autoresizesSubviews = defaultView.autoresizesSubviews
    defaultValues.contentScaleFactor = defaultView.contentScaleFactor
    defaultValues.isExclusiveTouch = defaultView.isExclusiveTouch
    defaultValues.autoresizingMask = defaultView.autoresizingMask
    defaultValues.clipsToBounds = defaultView.clipsToBounds
    defaultValues.layoutMargins = defaultView.layoutMargins
    defaultValues.transform = defaultView.transform.asCustomEncodable
    defaultValues.tag = defaultView.tag

    return defaultValues
}()
