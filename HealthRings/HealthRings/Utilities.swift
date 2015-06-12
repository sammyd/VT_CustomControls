//
//  File.swift
//  HealthRings
//
//  Created by Sam Davies on 12/06/2015.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import UIKit

public extension UIColor {
  public var darkerColor : UIColor {
    var hue : CGFloat = 0.0
    var saturation : CGFloat = 0.0
    var brightness : CGFloat = 0.0
    var alpha : CGFloat = 0.0
    getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
    return UIColor(hue: min(hue * 1.1, 1.0), saturation: saturation, brightness: brightness * 0.7, alpha: alpha)
  }
}

