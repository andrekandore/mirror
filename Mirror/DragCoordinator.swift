//
//  DragCoordinator.swift
//  Mirror
//
//  Created by アンドレ on 2/27/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import UIKit

class DragCoordinator: NSObject {
    
    @IBOutlet var square: UIView?
    
    @IBAction func panSqare(_ sender: UIPanGestureRecognizer) {
        
        guard let square = square else {
            return
        }
        
        let translation = sender.translation(in: square)
        sender.setTranslation(.zero, in: square)
        
        var center = square.center
        center.x += translation.x
        center.y += translation.y
        
        square.center = center
    }
}

/* Allow UIView Objects inside of this view to be dragged within and without, even if point is outside of the HitTest Area. */
class AnyHitTestView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self.subviews.compactMap { (subview: UIView) -> UIView? in
            if let view = subview.hitTest(subview.convert(point, from: self), with: event) {
                return view
            } else {
                return super.hitTest(point, with: event)
            }
            }.first ?? self
    }
}
