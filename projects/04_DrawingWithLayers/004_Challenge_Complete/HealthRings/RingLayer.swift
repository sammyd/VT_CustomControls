/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit


class RingLayer : CALayer {

  //:- Constituent Layers
  private lazy var backgroundLayer : CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.strokeColor = self.ringBackgroundColor
    layer.lineWidth = self.ringWidth
    layer.fillColor = nil
    return layer
  }()
  
  private lazy var gradientLayer : CircularGradientLayer = {
    let gradLayer = CircularGradientLayer()
    gradLayer.setValue(M_PI, forKeyPath: "transform.rotation.z")
    gradLayer.colours = self.ringColors
    return gradLayer
    }()
  
  private lazy var foregroundLayer : CALayer = {
    let layer = CALayer()
    layer.mask = self.foregroundMaskLayer
    layer.addSublayer(self.gradientLayer)
    return layer
    }()
  
  private lazy var foregroundMaskLayer : CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.lineCap = kCALineCapRound
    layer.lineWidth = self.ringWidth
    layer.fillColor = nil
    layer.strokeColor = UIColor.blackColor().CGColor
    return layer
    }()

  private let angleOffsetForZero = CGFloat(-M_PI_2)
  

  //:- Public API
  var ringWidth: CGFloat = 30.0
  var value: CGFloat = 0.7 {
    didSet {
      setRingValue(value)
    }
  }
  var ringColors: (CGColorRef, CGColorRef) = (UIColor.redColor().CGColor, UIColor.blackColor().CGColor)
  var ringBackgroundColor: CGColorRef = UIColor.darkGrayColor().CGColor

  var animationDuration = 5.0
  
  //:- Initialisation
  override init() {
    super.init()
    sharedInitialization()
  }
  
  override init(layer: AnyObject) {
    super.init(layer: layer)
    if let layer = layer as? RingLayer {
      ringWidth = layer.ringWidth
      value = layer.value
      ringBackgroundColor = layer.ringBackgroundColor
      ringColors = layer.ringColors
      animationDuration = layer.animationDuration
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    sharedInitialization()
  }
  
  private func sharedInitialization() {
    // Add the sublayers to the hierarchy
    for layer in [backgroundLayer, foregroundLayer] {
      addSublayer(layer)
    }
  }
}

extension RingLayer {
  //:- Lifecycle overrides
  override func layoutSublayers() {
    super.layoutSublayers()
    if gradientLayer.bounds != bounds {
      // Resize the sublayers
      for layer in [gradientLayer, backgroundLayer, foregroundLayer, foregroundMaskLayer] {
        layer.bounds = bounds
        layer.position = center
      }
      preparePaths()
    }
  }
  
  //:- Utility Methods
  private func preparePaths() {
    backgroundLayer.path = backgroundRingPath
    let toAngle = CGFloat(value * 2.0 * CGFloat(M_PI) + angleOffsetForZero)
    foregroundMaskLayer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: angleOffsetForZero, endAngle: toAngle, clockwise: true).CGPath
  }
 
  //:- Utility Properties
  private var radius : CGFloat {
    return (min(bounds.width, bounds.height) - ringWidth) / 2.0
  }
  
  private var backgroundRingPath : CGPathRef {
    return UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(2.0 * M_PI), clockwise: true).CGPath
  }
}


extension RingLayer {
  func setRingValue(value: CGFloat) {
    let toAngle = CGFloat(value * 2.0 * CGFloat(M_PI) + angleOffsetForZero)

    
    gradientLayer.setValue(toAngle + CGFloat(M_PI), forKeyPath: "transform.rotation.z")
    
    // Update the foreground mask path
    let maskPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: angleOffsetForZero, endAngle: toAngle, clockwise: true)
    foregroundMaskLayer.path = maskPath.CGPath
  }
}



