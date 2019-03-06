//
//  UISlider.swift
//  Mirror
//
//  Created by アンドレ on 3/6/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import UIKit


extension UISlider: IndirectlyDecodableView {
    
    func decodeAndApplyAdditionalProperties(from decoder: Decoder) {
        guard let container = try? decoder.container(keyedBy: Keys.self) else { return }
        self.minimumValueImage = (try? container.decodeIfPresent(CodableUIImage.self, forKey: .minimumValueImage))??.image
        self.maximumValueImage = (try? container.decodeIfPresent(CodableUIImage.self, forKey: .maximumValueImage))??.image
        self.minimumValue = (try? container.decode(Float.self, forKey: .minimumValue)) ?? 0
        self.maximumValue = (try? container.decode(Float.self, forKey: .maximumValue)) ?? 10
        self.isContinuous = (try? container.decode(Bool.self, forKey: .isContinuous)) ?? false
        self.value = (try? container.decode(Float.self, forKey: .value)) ?? 0
    }
    
    public func encodeAdditionalProperties(into encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try? container.encode(self.minimumValueImage?.codableSelf, forKey: .minimumValueImage)
        try? container.encode(self.maximumValueImage?.codableSelf, forKey: .maximumValueImage)
        try? container.encode(self.minimumValue, forKey: .minimumValue)
        try? container.encode(self.maximumValue, forKey: .maximumValue)
        try? container.encode(self.isContinuous, forKey: .isContinuous)
        try? container.encode(self.value, forKey: .value)
    }
    
    public static func new(from decoder: Decoder) -> Self {
        let newSlider = self.createNew()
        newSlider.decodeAndApplyBasicProperties(from: decoder)
        newSlider.decodeAndApplyAdditionalProperties(from: decoder)
        return newSlider
    }
    
    enum Keys: CodingKey {
        case minimumValueImage
        case maximumValueImage
        case minimumValue
        case maximumValue
        case isContinuous
        case value
    }
    
}

extension UISlider {
    public override static func createNew() -> Self {
        let newself = self.init()
        let slider = newself as UISlider
        slider.frame = CGRect.init(x: 0, y: 0, width: 100, height: 10)
        slider.backgroundColor = UIColor.clear
        slider.sizeToFit()
        return newself
    }
}
