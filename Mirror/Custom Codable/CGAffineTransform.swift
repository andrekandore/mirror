//
//  CGAffineTransform.swift
//  Mirror
//
//  Created by アンドレ on 3/11/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import CoreGraphics

class UIAffineTransform: CustomCodableWrapper, Codable {
    
    typealias Wrapped = CGAffineTransform
    var wrapped: Wrapped
    
    required init(with wrapped: Wrapped) {
        self.wrapped = wrapped
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(self.wrapped.a, forKey: Keys.scaleX)
        try container.encode(self.wrapped.b, forKey: Keys.sheerX)
        try container.encode(self.wrapped.c, forKey: Keys.sheerY)
        try container.encode(self.wrapped.d, forKey: Keys.scaleY)
        try container.encode(self.wrapped.tx, forKey: Keys.transformX)
        try container.encode(self.wrapped.ty, forKey: Keys.transformY)
    }
    
    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let scaleX = try container.decode(CGFloat.self, forKey: Keys.scaleX)
        let sheerX = try container.decode(CGFloat.self, forKey: Keys.sheerX)
        let sheerY = try container.decode(CGFloat.self, forKey: Keys.sheerY)
        let scaleY = try container.decode(CGFloat.self, forKey: Keys.scaleY)
        
        let transformX = try container.decode(CGFloat.self, forKey: Keys.transformX)
        let transformY = try container.decode(CGFloat.self, forKey: Keys.transformY)
     
        let transform = CGAffineTransform(
            a: scaleX,
            b: sheerX,
            c: sheerY,
            d: scaleY,
            tx: transformX,
            ty: transformY
        )
        
        self.init(with: transform)
    }
    
    enum Keys: CodingKey {
        /** a */
        case scaleX
        /** b */
        case sheerX
        /** c */
        case sheerY
        /** d */
        case scaleY
        /** tx */
        case transformX
        /** ty */
        case transformY
    }
}

extension CGAffineTransform: CustomCodableWrapperConvertable {
    typealias EncodableType = UIAffineTransform
    var asCustomEncodable: UIAffineTransform {
        return UIAffineTransform(with: self)
    }
}
