//
//  UIColor.swift
//  Mirror
//
//  Created by アンドレ on 3/9/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import UIKit

extension UIColor: Encodable {    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard true == self.getRed(&r, green: &g, blue: &b, alpha: &a) else { return }
        
        try? container.encode(r, forKey: Keys.r)
        try? container.encode(g, forKey: Keys.g)
        try? container.encode(b, forKey: Keys.b)
        try? container.encode(a, forKey: Keys.a)
    }
    
    enum Keys: CodingKey {
        case r
        case g
        case b
        case a
    }
}

class DecodableColor: UIColor, Decodable {
    public required convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: Keys.self)
        let type = CGFloat.self
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        (try? container.decodeIfPresent(type, forKey: Keys.r))?.do { r = $0 }
        (try? container.decodeIfPresent(type, forKey: Keys.g))?.do { g = $0 }
        (try? container.decodeIfPresent(type, forKey: Keys.b))?.do { b = $0 }
        (try? container.decodeIfPresent(type, forKey: Keys.a))?.do { a = $0 }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
