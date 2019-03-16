//
//  BasicDecodableView.swift
//  Mirror
//
//  Created by アンドレ on 3/6/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import UIKit

@objc class BasicDecodableView: UIView, CodableView {
    
    func encodeAdditionalProperties(into encoder: Encoder) throws {}
    
    static func new(from decoder: Decoder) -> Self {
        return (try? self.init(from: decoder)) ?? self.init(frame: .zero)
    }
    
    var finalClassForInstantiation: String?
    
    var subDecodableViews: [BasicDecodableView] = []
    var actualSelf: UIView? = nil
    
    required init?(coder aDecoder: NSCoder) {
        self.finalClassForInstantiation = nil
        super.init(frame: .zero)
    }
    
    required override init(frame: CGRect) {
        self.finalClassForInstantiation = nil
        super.init(frame: frame)
    }
    
    required convenience init(from decoder: Decoder) throws {
        
        let basicInfo = try type(of: self).decodeBasicProperties(from: decoder)
        
        self.init(frame: basicInfo.rect)
        self.backgroundColor = basicInfo.backgroundColor
        
        if basicInfo.coderClass != self.className {
            self.finalClassForInstantiation = basicInfo.coderClass
        } else {
            self.finalClassForInstantiation = UIView.className
        }
        
        (self as CodableView).decodeAndApplyBasicProperties(from: decoder)
        
        guard let classForInstantiation = self.finalClassForInstantiation else { return }
        guard let instantiationClass = NSClassFromString(classForInstantiation) else { return }
        guard let decodingClass = instantiationClass as? IndirectlyDecodableView.Type else { return }
        guard decodingClass != type(of: self) else { return }
        
        actualSelf = decodingClass.new(from: decoder) as? UIView
        debugPrint(actualSelf.debugDescription)
    }
    
}
