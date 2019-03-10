//
//  Extensions.swift
//  Mirror
//
//  Created by アンドレ on 3/2/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import UIKit

extension Array {
    func any(at index: Index) -> Element? {
        guard index >= 0, index < self.count else {
            return nil
        }
        return self[index]
    }
}

extension UIView {
    func testWithRandomColor() {
        let color = UIColor.init(hue: CGFloat(arc4random() % 256)/256.0, saturation: CGFloat(arc4random() % 256)/256.0, brightness: CGFloat(arc4random() % 256)/256.0, alpha: CGFloat(arc4random() % 256)/256.0)
        self.layer.backgroundColor = color.cgColor
    }
}

extension NSObject {
    var className: String {
        return String(NSStringFromClass(type(of: self)))
    }
    var shortClassName: String {
        return String(describing: type(of: self))
    }
}

extension NSObjectProtocol {
    static var className: String {
        return String(NSStringFromClass(self))
    }
    static var shortClassName: String {
        return String(describing: self)
    }
}

extension UIControl.State: Codable {}

extension UIButton {
    
    var highlightedTitle: String? {
        get {
            return self.title(for: .highlighted)
        } set {
            self.setTitle(newValue, for: .highlighted)
        }
    }
    
    var disabledTitle: String? {
        get {
            return self.title(for: .disabled)
        } set {
            self.setTitle(newValue, for: .disabled)
        }
    }
    
    var selectedTitle: String? {
        get {
            return self.title(for: .selected)
        } set {
            self.setTitle(newValue, for: .selected)
        }
    }
    
    var focusedTitle: String? {
        get {
            return self.title(for: .focused)
        } set {
            self.setTitle(newValue, for: .focused)
        }
    }
    
    var normalTitle: String? {
        get {
            return self.title(for: .normal)
        } set {
            self.setTitle(newValue, for: .normal)
        }
    }
    
}

extension Optional {
    func `do`(_ with: (Wrapped) -> Void) {
        if let unwrapped = self {
            with(unwrapped)
        }
    }
}

extension Optional where Wrapped: UIColor {
    var orClear: UIColor {
        if let color = self {
            return color
        }
        return UIColor.clear
    }
}
