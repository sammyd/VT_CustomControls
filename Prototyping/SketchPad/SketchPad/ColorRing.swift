//
//  ColorPicker.swift
//  SketchPad
//
//  Created by Sam Davies on 12/08/2015.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

@IBDesignable
class ColorRing : UIView {
  
  private let numberSegments = 400
  
  @IBInspectable
  var ringWidth : CGFloat = 2.0 {
    didSet {
      setNeedsDisplay()
    }
  }
}


extension ColorRing {
  override func drawRect(rect: CGRect) {
    if let cxt = UIGraphicsGetCurrentContext() {
      drawRainbowWheel(cxt, rect: rect)
    }
  }
}

extension ColorRing {
  private func drawRainbowWheel(context: CGContextRef, rect: CGRect) {
    CGContextSaveGState(context)
    
    let ringRadius = (min(rect.width, rect.height) - ringWidth) / 2
    
    CGContextSetLineWidth(context, ringWidth)
    CGContextSetLineCap(context, .Butt)
    
    for segment in 0 ..< numberSegments {
      let proportion = CGFloat(segment) / CGFloat(numberSegments)
      let startAngle = proportion * 2 * CGFloat(M_PI)
      let endAngle = CGFloat(segment + 1) / CGFloat(numberSegments) * 2 * CGFloat(M_PI)
      
      UIColor(hue: proportion, saturation: 1.0, brightness: 1.0, alpha: 1.0).setStroke()
      CGContextAddArc(context, rect.midX, rect.midY, ringRadius, startAngle, endAngle, 0)
      CGContextStrokePath(context)
    }
    
    CGContextRestoreGState(context)
  }
}
