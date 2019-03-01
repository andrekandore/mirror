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
        do {
            views = try decoder.decode([DecodableView].self, from: jsonData)
        } catch let error {
            debugPrint(error)
        }
        
        return views
    }
}

extension UIView: Encodable {
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: Keys.self)

        let rect = self.frame

        try container.encode(rect.origin.x, forKey: Keys.x)
        try container.encode(rect.origin.y, forKey: Keys.y)
        try container.encode(rect.size.width, forKey: Keys.width)
        try container.encode(rect.size.height, forKey: Keys.height)
        
        let color = self.backgroundColor ?? UIColor.black
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard true == color.getRed(&r, green: &g, blue: &b, alpha: &a) else { return }
        
        try container.encode(r, forKey: Keys.r)
        try container.encode(g, forKey: Keys.g)
        try container.encode(b, forKey: Keys.b)
        try container.encode(a, forKey: Keys.a)
    }
    
    enum Keys: CodingKey {
        case x
        case y
        case width
        case height
        case r
        case g
        case b
        case a
    }
}

@objc class DecodableView: UIView, Decodable {
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let x = try container.decode(CGFloat.self, forKey: Keys.x)
        let y = try container.decode(CGFloat.self, forKey: Keys.y)
        let width = try container.decode(CGFloat.self, forKey: Keys.width)
        let height = try container.decode(CGFloat.self, forKey: Keys.height)
        
        let rect = CGRect(x: x, y: y, width: width, height: height)
        
        let r = try container.decode(CGFloat.self, forKey: Keys.r)
        let g = try container.decode(CGFloat.self, forKey: Keys.g)
        let b = try container.decode(CGFloat.self, forKey: Keys.b)
        let a = try container.decode(CGFloat.self, forKey: Keys.a)
        
        let color = UIColor(red: r, green: g, blue: b, alpha: a)
        
        super.init(frame: rect)
        self.backgroundColor = color
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
