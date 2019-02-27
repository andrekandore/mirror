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
    
    @IBOutlet private weak var mirroredViewHeight: NSLayoutConstraint?
    @IBOutlet private weak var mirroredViewWidth: NSLayoutConstraint?
    @IBOutlet private var mirroredView: UIView?
    
    var mirrorCoordinator: MirrorCoordinator?
    private var displayLink: CADisplayLink?
    
    func addChildViewToMirror(_ view: UIView) {
        self.mirroredView?.addSubview(view)
    }
    
    var mirrorSizeRatio: CGSize = .zero {
        didSet {
            
            guard   mirrorSizeRatio != .zero,
//                    let width = mirroredViewWidth?.constant,
                    let height = mirroredViewHeight,
                    let view = mirroredView else {
                return
            }
            
            //TODO: make both height and width fit in device window + align to new ratio
            let currentSize = view.bounds
//            let currentRatio = currentSize.size.height / currentSize.size.width
            let newRatio = mirrorSizeRatio.height / mirrorSizeRatio.width
            let newHeight =  newRatio * currentSize.width 
            height.constant = newHeight
            
            self.mirroredView?.setNeedsUpdateConstraints()
            self.mirroredView?.setNeedsLayout()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.displayLink = CADisplayLink.init(target: self, selector: #selector(mirrorSelf))
        self.displayLink?.add(to: RunLoop.current, forMode: .default)
    }

    @objc func mirrorSelf() {
        guard mirrorSizeRatio != .zero else { return }
        mirrorCoordinator?.currentImage = self.mirroredView?.mirrorImage
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
