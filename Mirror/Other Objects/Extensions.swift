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
