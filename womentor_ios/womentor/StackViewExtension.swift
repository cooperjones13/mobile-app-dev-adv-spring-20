//
//  StackViewExtension.swift
//  womentor
//
//  Created by Cooper Jones on 5/7/20.
//  Copyright © 2020 Cooper Jones. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    func addBackgroundWithRadius(color: UIColor, cornerRadius: CGFloat) {
    
        
        let subView = UIView(frame: bounds.insetBy(dx:-8, dy: -8))
        subView.backgroundColor = color
        subView.layer.cornerRadius = cornerRadius
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        if subviews.count == 3 {subviews.first?.removeFromSuperview()}
        insertSubview(subView, at: 0)
        
    }
}

extension UIColor{
    func withSaturation(_ saturation:CGFloat) -> UIColor{
        var currHue: CGFloat = 0.0
        var currSaturation: CGFloat = 0.0
        var currBrightness: CGFloat = 0.0
        var currAlpha: CGFloat = 0.0
        
        if(self.getHue(&currHue, saturation: &currSaturation, brightness: &currBrightness, alpha: &currAlpha)){
            return UIColor(hue: currHue, saturation: saturation, brightness: currBrightness, alpha: currAlpha)
        } else{
            return self
        }
    }
}
