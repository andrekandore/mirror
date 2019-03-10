//
//  CodableViews.swift
//  Mirror
//
//  Created by アンドレ on 3/6/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import UIKit


/*
 MARK: - Encodable View Protocol -
 */
public protocol EncodableView: Encodable, CreatableView {
    typealias BasicProperties = ( backgroundColor: UIColor, coderClass: String, rect: CGRect )
    func encodeBasicProperties(into encoder: Encoder) throws
}

public protocol AdditionalPropertyEncodableView: EncodableView {
    func encodeAdditionalProperties(into encoder: Encoder) throws
}

/*
 MARK: - Decoodable View Protocol -
 */
public protocol DecodableView: EncodableView {
    static func decodeBasicProperties(from decoder: Decoder) throws -> BasicProperties
    
    func decodeAndApplyBasicProperties(from decoder: Decoder)
    func decodeAndApplyAdditionalProperties(from decoder: Decoder)
}

extension DecodableView {
    public func decodeAndApplyAdditionalProperties(from decoder: Decoder) {}
}

/*
 MARK: - Indirect Decoding -
 */
public protocol IndirectlyDecodableView: DecodableView & AdditionalPropertyEncodableView {
    static func new(from decoder: Decoder) -> Self
}

protocol CodableView: IndirectlyDecodableView & Decodable where Self: UIView {}


extension UIView {
    enum BasicCodingKeys: CodingKey {
        case additionalProperties
        case backgroundColor
        case classForCoder
        case frame
    }
}

extension UIView: Encodable {
    public func encode(to encoder: Encoder) throws {
        try (self as EncodableView).encodeBasicProperties(into: encoder)
        try (self as? AdditionalPropertyEncodableView)?.encodeAdditionalProperties(into: encoder)
    }
}

extension UIView: EncodableView {
    public func encodeBasicProperties(into encoder: Encoder) throws {
        var container = encoder.container(keyedBy: BasicCodingKeys.self)
        
        try? container.encode(AdditionalBasicProperties.init(from: self), forKey: BasicCodingKeys.additionalProperties)
        try? container.encode(self.backgroundColor.orClear, forKey: BasicCodingKeys.backgroundColor)
        try container.encode(self.frame.asCustomEncodable, forKey: BasicCodingKeys.frame)
        try container.encode(self.className, forKey: .classForCoder)
        
        debugPrint(self.className)
    }
}

extension UIView: DecodableView  {
    
    static public func decodeBasicProperties(from decoder: Decoder) throws -> BasicProperties {
        let container = try decoder.container(keyedBy: BasicCodingKeys.self)
        let backgroundColor = (try? container.decode(DecodableColor.self, forKey: BasicCodingKeys.backgroundColor)).orClear
        let coderClass = try container.decode(String.self, forKey: BasicCodingKeys.classForCoder)
        let frame = try container.decode(UIRect.self, forKey: BasicCodingKeys.frame).wrapped
        return (backgroundColor: backgroundColor, coderClass: coderClass, rect: frame)
    }
    
    public func decodeAndApplyBasicProperties(from decoder: Decoder) {
        
        guard let basicInformation
            = try? type(of: self).decodeBasicProperties(from: decoder) else {
            return
        }
        
        self.backgroundColor = basicInformation.backgroundColor
        self.frame = basicInformation.rect
        
        let container = try? decoder.container(keyedBy: BasicCodingKeys.self)
        let extraProperties = try? container?.decodeIfPresent(
            AdditionalBasicProperties.self,
            forKey: BasicCodingKeys.additionalProperties
        )
        
        extraProperties??.apply(to: self)
    }
    
}

