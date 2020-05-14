//
//  GradientView.swift
//  HistoricalPlaces
//
//  Created by Jiayi Xu on 23/03/2017.
//  Copyright © 2017 Jiayi Xu. All rights reserved.
//

import Foundation
import UIKit

class GradientView: UIView {
    override open class var layerClass: AnyClass {
        get{
            return CAGradientLayer.classForCoder()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = [ColorPalette.SegmentTint.cgColor, ColorPalette.Purple.cgColor, ColorPalette.SegmentTint.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    }
}
