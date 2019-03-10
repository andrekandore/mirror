//
//  CGRect.swift
//  Mirror
//
//  Created by アンドレ on 3/9/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import CoreGraphics

class UIRect: CustomCodableWrapper, Codable {
    
    typealias Wrapped = CGRect
    var wrapped: Wrapped

    required init(with wrapped: Wrapped) {
        self.wrapped = wrapped
    }
    
    public func encode(to encoder: Encoder) throws {
        self.wrapped.origin.customEncode(into: encoder)
        self.wrapped.size.customEncode(into: encoder)
    }
    
    required public convenience init(from decoder: Decoder) throws {
        self
            .init(with: CGRect (
                origin: CGPoint.customDecode(from: decoder),
                size: CGSize.customDecode(from: decoder)
            )
        )
    }
}

extension CGRect: CustomCodableWrapperConvertable {
    typealias EncodableType = UIRect
    var asCustomEncodable: UIRect {
        return UIRect(with: self)
    }
}
