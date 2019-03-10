//
//  CGPoint.swift
//  Mirror
//
//  Created by アンドレ on 3/9/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import CoreGraphics

extension CGPoint: CustomCodable {
    
    static func customDecode(from decoder: Decoder) -> CGPoint {
        let container = try? decoder.container(keyedBy: Keys.self)
        var newSelf = CGPoint.zero
        (try? container?.decode(CGFloat.self, forKey: Keys.x))?.do { newSelf.x = $0 }
        (try? container?.decode(CGFloat.self, forKey: Keys.y))?.do { newSelf.y = $0 }
        return newSelf
    }
    
    func customEncode(into coder: Encoder) {
        var container = coder.container(keyedBy: Keys.self)
        try? container.encode(self.x, forKey: Keys.x)
        try? container.encode(self.y, forKey: Keys.y)
    }
    
    enum Keys: CodingKey {
        case x
        case y
    }
}
