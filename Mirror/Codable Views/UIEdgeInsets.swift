//
//  UIEdgeInsets.swift
//  Mirror
//
//  Created by アンドレ on 3/9/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import UIKit

extension UIEdgeInsets: Codable {
    
    public init(from decoder: Decoder) throws {
        self.init(top: 0, left: 0, bottom: 0, right: 0)
        if let container = try? decoder.container(keyedBy: Keys.self) {
            (try? container.decodeIfPresent(CGFloat.self, forKey: Keys.bottom))?.do { value in self.bottom = value }
            (try? container.decodeIfPresent(CGFloat.self, forKey: Keys.right))?.do { value in self.right = value }
            (try? container.decodeIfPresent(CGFloat.self, forKey: Keys.left))?.do { value in self.left = value }
            (try? container.decodeIfPresent(CGFloat.self, forKey: Keys.top))?.do { value in self.top = value }
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try? container.encode(self.bottom, forKey: Keys.bottom)
        try? container.encode(self.right, forKey: Keys.right)
        try? container.encode(self.left, forKey: Keys.left)
        try? container.encode(self.top, forKey: Keys.top)
    }
    
    enum Keys: CodingKey {
        case top
        case left
        case bottom
        case right
    }
}
