//
//  CGSize.swift
//  Mirror
//
//  Created by アンドレ on 3/9/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import CoreGraphics

extension CGSize: CustomCodable {
    
    static func customDecode(from decoder: Decoder) -> CGSize {
        let container = try? decoder.container(keyedBy: Keys.self)
        var newSelf = CGSize.zero
        (try? container?.decode(CGFloat.self, forKey: Keys.height))?.do { newSelf.height = $0 }
        (try? container?.decode(CGFloat.self, forKey: Keys.width))?.do { newSelf.width = $0 }
        return newSelf
    }
    
    func customEncode(into coder: Encoder) {
        var container = coder.container(keyedBy: Keys.self)
        try? container.encode(self.height, forKey: Keys.height)
        try? container.encode(self.width, forKey: Keys.width)
    }
    
    enum Keys: CodingKey {
        case height
        case width
    }
}
