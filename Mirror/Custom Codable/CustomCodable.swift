//
//  CustomCodable.swift
//  Mirror
//
//  Created by アンドレ on 3/9/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import Foundation

protocol CustomEncodable {
    func customEncode(into coder: Encoder)
}

protocol CustomDecodable {
    static func customDecode(from: Decoder) -> Self
}

protocol CustomCodable: CustomEncodable & CustomDecodable {}
