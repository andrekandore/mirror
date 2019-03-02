//
//  DragCoordinator.swift
//  Mirror
//
//  Created by アンドレ on 2/27/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import UIKit

class DragCoordinator: NSObject {
    
    @IBOutlet private var gestureRecognizers: [UIGestureRecognizer] = []
    @IBOutlet private var draggableViews: [UIView] = []
    
    func addNewDraggableView(_ view: UIView) {
        let newPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panView(_:)))
        self.gestureRecognizers.append(newPanGestureRecognizer)
        view.addGestureRecognizer(newPanGestureRecognizer)
    }
    
    @IBAction private func panView(_ sender: UIPanGestureRecognizer) {
        
        guard let view = sender.view else {
            return
        }
        
        let translation = sender.translation(in: view)
        sender.setTranslation(.zero, in: view)
        
        var center = view.center
        center.x += translation.x
        center.y += translation.y
        
        view.center = center
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
