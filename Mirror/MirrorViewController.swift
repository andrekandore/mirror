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
