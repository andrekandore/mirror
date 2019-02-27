//
//  ViewCoordiator.swift
//  Mirror
//
//  Created by アンドレ on 2/28/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import UIKit

class ViewCoordiator: NSObject {
    
    @IBOutlet var projectorViewController: ProjectorViewController?
    @IBOutlet var dragCoordinator: DragCoordinator?
    
    @IBAction func createView(sender: Any?) {
        let newUIView = UIView(frame: CGRect(x: 200, y: 200, width: 128, height: 128))
        newUIView.testWithRandomColor()
        projectorViewController?.addChildViewToMirror(newUIView)
        dragCoordinator?.addNewDraggableView(newUIView)
    }
}
