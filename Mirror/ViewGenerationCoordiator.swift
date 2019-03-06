//
//  ViewCoordiator.swift
//  Mirror
//
//  Created by アンドレ on 2/28/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import UIKit
import WebKit

class ViewGenerationCoordiator: NSObject, ViewControllerDelegating {
    
    @IBOutlet var projectorViewController: ProjectorViewController?
    @IBOutlet var dragCoordinator: DragCoordinator?
    
    @IBAction func createTestView(sender: Any?) {
        let testUIView = UIView(frame: CGRect(x: 200, y: 200, width: 128, height: 128))
        testUIView.testWithRandomColor()
        self.addNew(testUIView)
    }

    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == ViewClassPickerViewController.shortClassName else {
            return
        }
        
        let destination = segue.destination
        guard let viewClassesViewController = (destination as? ViewClassPickerViewController)
                ?? (destination as? UINavigationController)?.viewControllers.first as? ViewClassPickerViewController else {
            return
        }
        
        viewClassesViewController.didPickViewClassCallback = { viewClass in
            
            debugPrint(viewClass)
            
            let initializedClass = viewClass.createNew()
            guard let viewClass = initializedClass as? UIView else {
                return
            }
            
            self.addNew(viewClass)
        }
    }
    
    func addNew(_ view: UIView) {
        projectorViewController?.addChildViewToMirror(view)
        dragCoordinator?.addNewDraggableView(view)
    }
}
