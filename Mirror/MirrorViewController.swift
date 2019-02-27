//
//  MirrorViewController.swift
//  Mirror
//
//  Created by アンドレ on 2/24/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import UIKit

class MirrorViewController: UIViewController {
    var image: UIImage? {
        didSet {
            self.view.layer.contents = self.image?.cgImage
//            self.view.testWithRandomColor()
        }
    }
}

extension UIView {
    func testWithRandomColor() {
        let color = UIColor.init(hue: CGFloat(arc4random() % 256)/256.0, saturation: CGFloat(arc4random() % 256)/256.0, brightness: CGFloat(arc4random() % 256)/256.0, alpha: CGFloat(arc4random() % 256)/256.0)
        self.layer.backgroundColor = color.cgColor
    }
}
