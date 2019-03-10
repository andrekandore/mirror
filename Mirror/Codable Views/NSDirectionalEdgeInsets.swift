//
//  NSDirectionalEdgeInsets.swift
//  Mirror
//
//  Created by アンドレ on 3/9/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import UIKit

extension NSDirectionalEdgeInsets: Codable {
    
    public init(from decoder: Decoder) throws {
        self.init(top: 0, leading: 0, bottom: 0, trailing: 0)
        if let container = try? decoder.container(keyedBy: Keys.self) {
            (try? container.decodeIfPresent(CGFloat.self, forKey: Keys.trailing))?.do { value in self.trailing = value }
            (try? container.decodeIfPresent(CGFloat.self, forKey: Keys.leading))?.do { value in self.leading = value }
            (try? container.decodeIfPresent(CGFloat.self, forKey: Keys.bottom))?.do { value in self.top = value }
            (try? container.decodeIfPresent(CGFloat.self, forKey: Keys.top))?.do { value in self.top = value }
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try? container.encode(self.trailing, forKey: Keys.trailing)
        try? container.encode(self.leading, forKey: Keys.leading)
        try? container.encode(self.bottom, forKey: Keys.bottom)
        try? container.encode(self.top, forKey: Keys.top)
    }
    
    enum Keys: CodingKey {
        case top
        case leading
        case bottom
        case trailing
    }
    
}
