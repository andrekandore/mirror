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
