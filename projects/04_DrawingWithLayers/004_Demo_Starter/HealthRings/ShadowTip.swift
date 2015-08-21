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

class ShadowTip : CALayer {
  
  //MARK:- Constituent Layers
  private lazy var tipLayer : CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.lineCap = kCALineCapRound
    return layer
    }()
  
  private lazy var shadowLayer : CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.lineCap = kCALineCapRound
    layer.strokeColor = UIColor.blackColor().CGColor
    layer.shadowColor = UIColor.blackColor().CGColor
    layer.shadowOffset = CGSize.zeroSize
    layer.shadowRadius = 12.0
    layer.shadowOpacity = 1.0
    layer.mask = self.shadowMaskLayer
    return layer
    }()
  
  private lazy var shadowMaskLayer : CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.strokeColor = UIColor.blackColor().CGColor
    layer.lineCap = kCALineCapButt
    return layer
    }()
  
  //MARK:- Utility Properties
  private var radius : CGFloat {
    return (min(bounds.width, bounds.height) - ringWidth) / 2.0
  }
  
  private var shadowMaskPath : CGPathRef {
    return UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(M_PI_2), clockwise: true).CGPath
  }
  
  private var tipPath : CGPathRef {
    return UIBezierPath(arcCenter: center, radius: radius, startAngle: -0.01, endAngle: 0, clockwise: true).CGPath
  }
  
  //MARK:- API Properties
  var color: CGColorRef = UIColor.redColor().CGColor {
    didSet {
      tipLayer.strokeColor = color
    }
  }
  
  var ringWidth: CGFloat = 20.0 {
    didSet {
      tipLayer.lineWidth = ringWidth
      shadowLayer.lineWidth = ringWidth
      shadowMaskLayer.lineWidth = ringWidth
      preparePaths()
    }
  }
  
  //MARK:- Initialisation
  override init() {
    super.init()
    sharedInitialisation()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    sharedInitialisation()
  }
  
  override init(layer: AnyObject) {
    super.init(layer: layer)
    if let layer = layer as? ShadowTip {
      color = layer.color
      ringWidth = layer.ringWidth
    }
  }
  
  private func sharedInitialisation() {
    addSublayer(shadowLayer)
    addSublayer(tipLayer)
    color = UIColor.redColor().CGColor
    ringWidth = 20.0
  }
  
  //MARK:- Lifecycle Overrides
  override func layoutSublayers() {
    for layer in [tipLayer, shadowLayer, shadowMaskLayer] {
      layer.bounds = bounds
      layer.position = center
    }
    preparePaths()
  }
  
  //MARK:- Utility methods
  private func preparePaths() {
    tipLayer.path = tipPath
    shadowLayer.path = tipPath
    shadowMaskLayer.path = shadowMaskPath
  }
}
