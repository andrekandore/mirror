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
                
                guard let classForInstantiation = view.finalClassForInstantiation else { continue }
                guard let cClassName = UnsafePointer<Int8>(classForInstantiation.cString(using: .utf8)) else { continue }
                guard let instantiationClass = objc_getClass(cClassName) as? NSObjectProtocol.Type else { continue }
                guard let decodingClass = instantiationClass as? DecodableView.Type else { continue }
                debugPrint(decodingClass)
                
//                guard let aNewObject = decodingClass.new(from: decoder) else { continue }
                
            }
//            views = intermediateViews//= try decoder.decode([UIView].self, from: jsonData)
        } catch let error {
            debugPrint(error)
        }
        
        return views
    }
}

public protocol EncodableView: Encodable, NSObjectProtocol {
    
    typealias BasicInformation = (
        backgroundColor: UIColor,
        coderClass: String,
        rect: CGRect
    )
    
    static func decodeBasicInformation(from decoder: Decoder) throws -> BasicInformation
    
    func encodeAdditionalProperties(into encoder: Encoder)
    static func createNew() -> Self
}

//public protocol IntermediateDecodableView: EncodableView {}

public protocol DecodableView: EncodableView {
    func decodeAndApplyAdditionalProperties(from decoder: Decoder)
    static func new(from decoder: Decoder) -> Self
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

extension EncodableView {
    public func decodeAndApplyAdditionalProperties(from decoder: Decoder) {}
    public func encodeAdditionalProperties(into encoder: Encoder) {}
}

extension UIView: EncodableView {

    @objc public class func createNew() -> Self {
        return self.init()
    }

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
    
    public func decodeAndApplyBasicProperties(from decoder: Decoder) throws {
        
        let basicInformation = try type(of: self).decodeBasicInformation(from: decoder)
        self.frame = basicInformation.rect
        self.backgroundColor = basicInformation.backgroundColor
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
        
        self.encodeAdditionalProperties(into: encoder)
    }
    
}

class BasicDecodableView: UIView, DecodableView, Decodable {
    
    static func new(from decoder: Decoder) -> Self {
        return try! self.init(from: decoder)
    }
    
    var finalClassForInstantiation: String?
    
    var subDecodableViews: [BasicDecodableView] = []
    var actualSelf: UIView? = nil
    
    required init?(coder aDecoder: NSCoder) {
        self.finalClassForInstantiation = nil
        super.init(frame: .zero)
    }
    
    required override init(frame: CGRect) {
        self.finalClassForInstantiation = nil
        super.init(frame: frame)
    }
    
    required convenience init(from decoder: Decoder) throws {
        let basicInfo = try type(of: self).decodeBasicInformation(from: decoder)
        self.init(frame: basicInfo.rect)
        self.finalClassForInstantiation = basicInfo.coderClass
        self.backgroundColor = basicInfo.backgroundColor
    }
    
}

extension UISlider: DecodableView {
    
    public func decodeAndApplyAdditionalProperties(from decoder: Decoder) {
        
    }
    
    public func encodeAdditionalProperties(into encoder: Encoder) {
        
    }
    
    
    public static func new(from decoder: Decoder) -> Self {
        let basicData = try? self.decodeBasicInformation(from: decoder)
//        let additionalData = self.decodeAdditionalInformation(from: decoder)
        let newObject = self.init(frame: basicData?.rect ?? .zero)
        return newObject
    }
    
    enum Keys: CodingKey {
        case minimumValueImage
        case maximumValueImage
        case minimumValue
        case maximumValue
        case isContinuous
        case value
    }
    
}

extension UIButton: DecodableView {
    
    public func encodeAdditionalProperties(into encoder: Encoder) {
        
    }
    
    public func decodeAndApplyAdditionalProperties(from decoder: Decoder) {
        
    }
    
    public static func new(from decoder: Decoder) -> Self {
        
        guard let container = try? decoder.container(keyedBy: Keys.self) else {
            return self.init()
        }
        
        let type = try? container.decode(Int.self, forKey: Keys.ButtonType)
        let newButton = self.init(type: ButtonType(rawValue: type ?? 0) ?? .system)
        try? newButton.decodeAndApplyBasicProperties(from: decoder)
        newButton.decodeAndApplyAdditionalProperties(from: decoder)
        
        return newButton
    }
    
    enum Keys: CodingKey {
        case ButtonType
    }
 
    public override static func createNew() -> Self {
        let newself = self.init(type: .system)
        
        let button = newself as UIButton
        button.frame = CGRect.init(x: 0, y: 0, width: 10, height: 10)
        button.setTitle("Button", for: .normal)
        button.sizeToFit()
        
        return newself
    }

}
