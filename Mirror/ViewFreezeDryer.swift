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
        do {
            let intermediateViews = try decoder.decode([IntermediateDecodableView].self, from: jsonData)
            for view in intermediateViews {
                debugPrint(view.finalClassForInstantiation ?? "")
            }
            views = intermediateViews//= try decoder.decode([UIView].self, from: jsonData)
        } catch let error {
            debugPrint(error)
        }
        
        return views
    }
}

public protocol EncodableView: Encodable {
    
    typealias BasicInformation = (
        backgroundColor: UIColor,
        coderClass: String,
        rect: CGRect
    )
    
    static func decodeBasicInformation(from decoder: Decoder) throws -> BasicInformation

    func encodeAdditionalInformation(into encoder: Encoder)
    func decodeAdditionalInformation(from decoder: Decoder)
}

public protocol DecodableView: EncodableView, Decodable {
}

extension UIView {
    enum BasicCodingKeys: CodingKey {
        case x
        case y
        case width
        case height
        case r
        case g
        case b
        case a
        case classForCoder
    }
}

extension UIView: EncodableView {
    
    static public func decodeBasicInformation(from decoder: Decoder) throws -> BasicInformation {
        
        let container = try decoder.container(keyedBy: BasicCodingKeys.self)
        
        let height = try container.decode(CGFloat.self, forKey: BasicCodingKeys.height)
        let width = try container.decode(CGFloat.self, forKey: BasicCodingKeys.width)
        let x = try container.decode(CGFloat.self, forKey: BasicCodingKeys.x)
        let y = try container.decode(CGFloat.self, forKey: BasicCodingKeys.y)
        
        
        let rect = CGRect(x: x, y: y, width: width, height: height)
        
        let r = try container.decode(CGFloat.self, forKey: BasicCodingKeys.r)
        let g = try container.decode(CGFloat.self, forKey: BasicCodingKeys.g)
        let b = try container.decode(CGFloat.self, forKey: BasicCodingKeys.b)
        let a = try container.decode(CGFloat.self, forKey: BasicCodingKeys.a)
        
        let color = UIColor(red: r, green: g, blue: b, alpha: a)
        
        let coderClass = try container.decode(String.self, forKey: BasicCodingKeys.classForCoder)
        debugPrint(coderClass)
        
        return (backgroundColor: color, coderClass: coderClass, rect: rect)
    }
    
    public func decodeAdditionalInformation(from decoder: Decoder) {
        //debugPrint(#function)
    }
    
    
    public func encodeAdditionalInformation(into encoder: Encoder) {
        //debugPrint(#function)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: BasicCodingKeys.self)

        let rect = self.frame

        try container.encode(rect.origin.x, forKey: BasicCodingKeys.x)
        try container.encode(rect.origin.y, forKey: BasicCodingKeys.y)
        try container.encode(rect.size.width, forKey: BasicCodingKeys.width)
        try container.encode(rect.size.height, forKey: BasicCodingKeys.height)
        
        let color = self.backgroundColor ?? UIColor.black
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard true == color.getRed(&r, green: &g, blue: &b, alpha: &a) else { return }
        
        try container.encode(r, forKey: BasicCodingKeys.r)
        try container.encode(g, forKey: BasicCodingKeys.g)
        try container.encode(b, forKey: BasicCodingKeys.b)
        try container.encode(a, forKey: BasicCodingKeys.a)
        
        try container.encode(self.className, forKey: .classForCoder)
        debugPrint(self.className)
        
        self.encodeAdditionalInformation(into: encoder)
    }
    
}

class IntermediateDecodableView: UIView, DecodableView {
    
    var finalClassForInstantiation: String?
    
    required init?(coder aDecoder: NSCoder) {
        self.finalClassForInstantiation = nil
        super.init(frame: .zero)
    }
    
    required override init(frame: CGRect) {
        self.finalClassForInstantiation = nil
        super.init(frame: frame)
    }
    
    required convenience init(from decoder: Decoder) throws {
        let basicInfo = try UIView.decodeBasicInformation(from: decoder)
        self.init(frame: basicInfo.rect)
        self.finalClassForInstantiation = basicInfo.coderClass
        self.backgroundColor = basicInfo.backgroundColor
        
    }
}
