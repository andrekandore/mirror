//
//  UIViewExtraProperties.swift
//  Mirror
//
//  Created by アンドレ on 3/10/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import UIKit

extension UIView {
    class AdditionalBasicProperties: Codable {
        var semanticContentAttribute: UISemanticContentAttribute?
        var insetsLayoutMarginsFromSafeArea: Bool?
        var preservesSuperviewLayoutMargins: Bool?
        var autoresizingMask: AutoresizingMask?
        var isUserInteractionEnabled: Bool?
        var transform: CGAffineTransform?
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
    convenience init(from view: UIView) {
        self.init()
        self.insetsLayoutMarginsFromSafeArea = view.insetsLayoutMarginsFromSafeArea
        self.preservesSuperviewLayoutMargins = view.preservesSuperviewLayoutMargins
        self.isUserInteractionEnabled = view.isUserInteractionEnabled
        self.semanticContentAttribute = view.semanticContentAttribute
        self.isMultipleTouchEnabled = view.isMultipleTouchEnabled
        self.autoresizesSubviews = view.autoresizesSubviews
        self.contentScaleFactor = view.contentScaleFactor
        self.isExclusiveTouch = view.isExclusiveTouch
        self.autoresizingMask = view.autoresizingMask
        self.clipsToBounds = view.clipsToBounds
        self.layoutMargins = view.layoutMargins
        self.transform = view.transform
        self.tag = view.tag
    }
}

extension UIView.AdditionalBasicProperties {
    func apply(to view: UIView) {
        self.insetsLayoutMarginsFromSafeArea.do { view.insetsLayoutMarginsFromSafeArea = $0 }
        self.preservesSuperviewLayoutMargins.do { view.preservesSuperviewLayoutMargins = $0 }
        self.isUserInteractionEnabled.do { view.isUserInteractionEnabled = $0 }
        self.semanticContentAttribute.do { view.semanticContentAttribute = $0 }
        self.isMultipleTouchEnabled.do { view.isMultipleTouchEnabled = $0 }
        self.autoresizesSubviews.do { view.autoresizesSubviews = $0 }
        self.contentScaleFactor.do { view.contentScaleFactor = $0 }
        self.isExclusiveTouch.do { view.isExclusiveTouch = $0 }
        self.autoresizingMask.do { view.autoresizingMask = $0 }
        self.clipsToBounds.do { view.clipsToBounds = $0 }
        self.layoutMargins.do { view.layoutMargins = $0 }
        self.transform.do { view.transform = $0 }
        self.tag.do { view.tag = $0 }
    }
}

//        enum Keys: CodingKey {
//            case insetsLayoutMarginsFromSafeArea
//            case preservesSuperviewLayoutMargins
//            case isUserInteractionEnabled
//            case semanticContentAttribute
//            case isMultipleTouchEnabled
//            case autoresizesSubviews
//            case contentScaleFactor
//            case isExclusiveTouch
//            case autoresizingMask
//            case backgroundColor
//            case safeAreaInsets
//            case clipsToBounds
//            case classForCoder
//            case layoutMargins
//            case transform
//            case frame
//            case tag
//        }
