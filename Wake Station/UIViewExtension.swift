//
//  UIViewExtension.swift
//  Wake Station
//
//  Created by Jashan Shewakramani on 2018-07-08.
//  Copyright © 2018 Jashan Shewakramani. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

extension UIView {
    
    struct ShadowProperties {
        let color: CGColor?
        let offset: CGSize?
        let radius: CGFloat
        let opacity: Float
        
        init(color: CGColor?,
             offset: CGSize?,
             radius: CGFloat,
             opacity: Float) {
            self.color = color
            self.offset = offset
            self.radius = radius
            self.opacity = opacity
        }
        
        init(color: UIColor?,
             offset: CGSize?,
             radius: CGFloat,
             opacity: Float) {
            self.color = color?.cgColor
            self.offset = offset
            self.radius = radius
            self.opacity = opacity
        }
    }
    
    static let defaultShadowProperties = ShadowProperties(
        color: Colors.grayLight,
        offset: nil,
        radius: 6,
        opacity: 0.6
    )
    
    static let defaultShadowOffset = CGSize(width: 0, height: 3)
    
    func wrapShadow(withProperties properties: ShadowProperties) {
        guard let superview = self.superview else {
            return
        }
        
        let shadowContainerView = UIView(frame: .zero)
        shadowContainerView.clipsToBounds = false
    
        superview.insertSubview(shadowContainerView, belowSubview: self)
        shadowContainerView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        let shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        shadowContainerView.layer.shadowColor = properties.color
        shadowContainerView.layer.shadowOffset = properties.offset ?? UIView.defaultShadowOffset
        shadowContainerView.layer.shadowRadius = properties.radius
        shadowContainerView.layer.shadowOpacity = properties.opacity
        shadowContainerView.layer.shadowPath = shadowPath
    }
    
    func roundCorners(withRadius radius: CGFloat = 6) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func addBorder(withColor color: UIColor, thickness: CGFloat) {
        self.layer.borderWidth = thickness
        self.layer.borderColor = color.cgColor
    }
}
