//
//  UIButton.swift
//  Mirror
//
//  Created by アンドレ on 3/6/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import UIKit

extension UIButton: IndirectlyDecodableView {
    
    private static func typeForInit(from decoder: Decoder) -> ButtonType {
        return (try? decoder.container(keyedBy: Keys.self).decode(UIButton.ButtonType.self, forKey: Keys.buttonType)) ?? .system
    }
    
    func decodeAndApplyAdditionalProperties(from decoder: Decoder) {
        guard let container = try? decoder.container(keyedBy: Keys.self) else { return }
        self.highlightedTitle = try? container.decode(String.self, forKey: .highlightedTitle)
        self.disabledTitle = try? container.decode(String.self, forKey: .disabledTitle)
        self.selectedTitle = try? container.decode(String.self, forKey: .selectedTitle)
        self.focusedTitle = try? container.decode(String.self, forKey: .focusedTitle)
        self.normalTitle = try? container.decode(String.self, forKey: .normalTitle)
    }
    
    public func encodeAdditionalProperties(into encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try? container.encode(self.highlightedTitle, forKey: .highlightedTitle)
        try? container.encode(self.disabledTitle, forKey: .disabledTitle)
        try? container.encode(self.selectedTitle, forKey: .selectedTitle)
        try? container.encode(self.focusedTitle, forKey: .focusedTitle)
        try? container.encode(self.normalTitle, forKey: .normalTitle)
    }
    
    public static func new(from decoder: Decoder) -> Self {
        let newButton = self.init(type: self.typeForInit(from: decoder))
        newButton.decodeAndApplyBasicProperties(from: decoder)
        newButton.decodeAndApplyAdditionalProperties(from: decoder)
        return newButton
    }
    
    enum Keys: CodingKey {
        case highlightedTitle
        case disabledTitle
        case selectedTitle
        case focusedTitle
        case normalTitle
        case buttonType
    }
    
}

extension UIButton.ButtonType: Codable {}

extension UIButton {
    public override static func createNew() -> Self {
        let newself = self.init(type: .system)
        
        let button = newself as UIButton
        button.frame = CGRect.init(x: 0, y: 0, width: 10, height: 10)
        button.backgroundColor = UIColor.clear
        button.setTitle("Button", for: .normal)
        button.sizeToFit()
        
        return newself
    }
}
