//
//  Canvas.swift
//  SketchPad
//
//  Created by Sam Davies on 12/08/2015.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

@IBDesignable
class Canvas : UIView {
  
  private var drawing: UIImage?
  
  @IBInspectable
  var strokeWidth : CGFloat = 4.0
  
  @IBInspectable
  var strokeColor : UIColor = UIColor.blackColor()
}

extension Canvas {
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let touch = touches.first {
      addLineFromPoint(touch.previousLocationInView(self), toPoint: touch.locationInView(self))
    }
  }
}

extension Canvas {
  private func addLineFromPoint(from: CGPoint, toPoint: CGPoint) {
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
    
    drawing?.drawInRect(bounds)
    
    let cxt = UIGraphicsGetCurrentContext()
    CGContextMoveToPoint(cxt, from.x, from.y)
    CGContextAddLineToPoint(cxt, toPoint.x, toPoint.y)
    
    CGContextSetLineCap(cxt, .Round)
    CGContextSetLineWidth(cxt, strokeWidth)
    strokeColor.setStroke()
    
    CGContextStrokePath(cxt)
    
    drawing = UIGraphicsGetImageFromCurrentImageContext()
    
    layer.contents = drawing?.CGImage
    
    UIGraphicsEndImageContext()
  }
  
}
