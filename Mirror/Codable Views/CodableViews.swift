//
//  CodableViews.swift
//  Mirror
//
//  Created by アンドレ on 3/6/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import UIKit

public protocol CreatableView: NSObjectProtocol {
    static func createNew() -> Self
}

extension UIView: CreatableView {
    @objc public class func createNew() -> Self {
        return self.init()
    }
}

public protocol EncodableView: Encodable, CreatableView {
    
    typealias BasicProperties = (
        backgroundColor: UIColor,
        coderClass: String,
        rect: CGRect
    )
    
    func encodeBasicProperties(into encoder: Encoder) throws
}

public protocol AdditionalEncodableView: EncodableView {
    func encodeAdditionalProperties(into encoder: Encoder) throws
}

extension UIView: EncodableView {
    public func encodeBasicProperties(into encoder: Encoder) throws {
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
    }
}

public protocol DecodableView: EncodableView {
    static func decodeBasicProperties(from decoder: Decoder) throws -> BasicProperties
    
    func decodeAndApplyBasicProperties(from decoder: Decoder)
    func decodeAndApplyAdditionalProperties(from decoder: Decoder)
}

public protocol IndirectlyDecodableView: DecodableView & AdditionalEncodableView {
    static func new(from decoder: Decoder) -> Self
}

protocol CodableView: IndirectlyDecodableView & Decodable {}

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

extension DecodableView {
    public func decodeAndApplyAdditionalProperties(from decoder: Decoder) {}
}

extension UIView: Encodable {
    public func encode(to encoder: Encoder) throws {
        try (self as EncodableView).encodeBasicProperties(into: encoder)
        try (self as? AdditionalEncodableView)?.encodeAdditionalProperties(into: encoder)
    }
}


extension UIView: DecodableView  {
    
    static public func decodeBasicProperties(from decoder: Decoder) throws -> BasicProperties {
        
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
    
    public func decodeAndApplyBasicProperties(from decoder: Decoder) {
        guard let basicInformation = try? type(of: self)
            .decodeBasicProperties(from: decoder) else { return }
        self.frame = basicInformation.rect
        self.backgroundColor = basicInformation.backgroundColor
    }
    
}
