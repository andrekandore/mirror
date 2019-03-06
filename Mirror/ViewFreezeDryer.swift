//
//  ViewFreezeDryer.swift
//  Mirror
//
//  Created by アンドレ on 2/28/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import UIKit

class ViewFreezeDryer: NSObject {
    
    @IBOutlet var freezeDryView: UIView?

    private var didActivateObservers: [String: ObserverCallback] = [:]
    typealias ObserverCallback = ([UIView]) -> Void
    
    func addActivationObserver(for identifier: String, _ observer: @escaping ObserverCallback) {
        self.didActivateObservers[identifier] = observer
    }
    
    func removeActivationObserverFor(identifier: String) {
        self.didActivateObservers[identifier] = nil
    }
    
    override init() {
        super.init()
     
        NotificationCenter.default
            .addObserver(self, selector: #selector(passivateToStorage), name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default
            .addObserver(self, selector: #selector(passivateToStorage), name: UIApplication.willTerminateNotification, object: nil)
        
        NotificationCenter.default
            .addObserver(self, selector: #selector(activateFromStorage), name: UIApplication.didFinishLaunchingNotification, object: nil)
    }
}

extension ViewFreezeDryer {
    @objc func activateFromStorage() {
        
        let dataPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString).appendingPathComponent("Views.json")
        let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: dataPath))
        
        let dehydratedViews = self.rehydrateViews(from: data ?? Data())
        for view in dehydratedViews {
            self.freezeDryView?.addSubview(view)
        }
        
        for (offset: _, element: (key: _, value: observer)) in self.didActivateObservers.enumerated() {
            observer(dehydratedViews)
        }
    }
    
    @objc func passivateToStorage() {
        
        let dataPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString).appendingPathComponent("Views.json")
        
        let freezDryedViews = self.freezeDryViewToJSON()
        do {
            try freezDryedViews?.write(to: URL.init(fileURLWithPath: dataPath), options: .atomic)
        } catch let error {
            debugPrint(error)
        }
    }

}

extension ViewFreezeDryer {
    func freezeDryViewToJSON(with coder: JSONEncoder = JSONEncoder()) -> Data? {
        
        guard let freezeDryView = freezeDryView else {
            return nil
        }
        
        let allViews = freezeDryView.subviews
        let data: Data?
        do {
            data = try coder.encode(allViews)
        } catch let error {
            debugPrint(error)
            data = nil
        }
        
        return data
    }
    
    func rehydrateViews(from jsonData: Data, using decoder: JSONDecoder = JSONDecoder()) -> [UIView] {
        
        var views: [UIView] = []
        views = []
        do {
            var _: Decodable? = nil
            let intermediateViews = try decoder.decode([BasicDecodableView].self, from: jsonData)
            for view in intermediateViews {

                if let actualView = view.actualSelf {
                    views.append(actualView)
                } else {
                    views.append(view)
                }

            }
        } catch let error {
            debugPrint(error)
        }
        
        return views
    }
}
