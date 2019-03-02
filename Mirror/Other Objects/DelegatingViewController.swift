//
//  DelegatingViewController.swift
//  Mirror
//
//  Created by アンドレ on 3/2/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import UIKit

/*
 MARK: - Delegate Lifecycle Methods -
 */
class DelegatingViewController: UIViewController {
    
    @IBOutlet var delegates: [ViewControllerDelegating] = []
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        self.delegates.unwind(for: unwindSegue, towards: subsequentVC)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        self.delegates.prepare(for: segue, sender: sender)
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        self.delegates.willMove(toParent: parent)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        self.delegates.didMove(toParent: parent)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.delegates.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.delegates.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.delegates.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.delegates.viewDidAppear(animated)
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.delegates.prepareForInterfaceBuilder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.delegates.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.delegates.viewDidLayoutSubviews()
    }
}

/*
 MARK: - Lifecycle Method Definitions -
 */
@objc protocol ViewControllerDelegating: class {
    @objc optional func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController)
    @objc optional func prepare(for segue: UIStoryboardSegue, sender: Any?)
    
    @objc optional func willMove(toParent parent: UIViewController?)
    @objc optional func didMove(toParent parent: UIViewController?)
    
    @objc optional func viewWillDisappear(_ animated: Bool)
    @objc optional func viewDidDisappear(_ animated: Bool)
    @objc optional func viewWillAppear(_ animated: Bool)
    @objc optional func viewDidAppear(_ animated: Bool)
    
    @objc optional func prepareForInterfaceBuilder()
    @objc optional func didReceiveMemoryWarning()
    @objc optional func viewDidLayoutSubviews()
}

/*
 MARK: - Convenience Method for Accessing by Array -
 */
extension Array where Element: ViewControllerDelegating {
    
    func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        for delegate in self {
            delegate.unwind?(for: unwindSegue, towards: subsequentVC)
        }
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?){
        for delegate in self {
            delegate.prepare?(for: segue, sender: sender)
        }
    }
    
    func willMove(toParent parent: UIViewController?){
        for delegate in self {
            delegate.willMove?(toParent: parent)
        }
    }
    
    func didMove(toParent parent: UIViewController?){
        for delegate in self {
            delegate.didMove?(toParent: parent)
        }
    }
    
    func viewWillDisappear(_ animated: Bool){
        for delegate in self {
            delegate.viewWillDisappear?(animated)
        }
    }
    
    func viewDidDisappear(_ animated: Bool){
        for delegate in self {
            delegate.viewDidDisappear?(animated)
        }
    }
    
    func viewWillAppear(_ animated: Bool){
        for delegate in self {
            delegate.viewWillAppear?(animated)
        }
    }
    
    func viewDidAppear(_ animated: Bool){
        for delegate in self {
            delegate.viewDidAppear?(animated)
        }
    }
    
    func prepareForInterfaceBuilder(){
        for delegate in self {
            delegate.prepareForInterfaceBuilder?()
        }
    }
    
    func didReceiveMemoryWarning(){
        for delegate in self {
            delegate.didReceiveMemoryWarning?()
        }
    }
    
    func viewDidLayoutSubviews(){
        for delegate in self {
            delegate.viewDidLayoutSubviews?() }
    }
}
