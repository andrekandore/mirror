//
//  ViewController.swift
//  Mirror
//
//  Created by アンドレ on 2/24/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import UIKit
import CoreVideo

class ProjectorViewController: UIViewController {

    @IBOutlet var mirrorView: UIView?
    
    var displayLink: CADisplayLink?
    var mirrorCoordinator: MirrorCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.displayLink = CADisplayLink.init(target: self, selector: #selector(mirrorSelf))
        self.displayLink?.add(to: RunLoop.current, forMode: .default)
    }

    @objc func mirrorSelf() {
        mirrorCoordinator?.currentImage = self.mirrorView?.mirrorImage
    }

}

extension UIView {
    var mirrorImage: UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
