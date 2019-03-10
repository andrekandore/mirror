//
//  CustomCodableWrapper.swift
//  Mirror
//
//  Created by アンドレ on 3/9/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import Foundation

protocol CustomCodableWrapper where Wrapped: CustomCodableWrapperConvertable {
    associatedtype Wrapped
    init(with wrapped: Wrapped)
    var wrapped: Wrapped { get }
}

protocol CustomCodableWrapperConvertable {
    associatedtype EncodableType
    var asCustomEncodable: EncodableType { get }
}
