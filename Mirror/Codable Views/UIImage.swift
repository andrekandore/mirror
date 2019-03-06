//
//  UIImage.swift
//  Mirror
//
//  Created by アンドレ on 3/6/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import UIKit

extension UIImage {
    var codableSelf: CodableUIImage {
        return CodableUIImage(with: self)
    }
}

class CodableUIImage: Codable {
    
    var image: UIImage = UIImage()
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let data = (try? container.decode(Data.self, forKey: Keys.pngData)) ?? Data()
        self.image = UIImage.init(data: data) ?? UIImage()
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(self.image.pngData(), forKey: Keys.pngData)
    }
    
    init(with image: UIImage) {
        self.image = image
    }
    
    enum Keys: CodingKey {
        case pngData
    }
    
}
