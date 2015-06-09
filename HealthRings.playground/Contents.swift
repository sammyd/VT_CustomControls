//: Playground - noun: a place where people can play

import UIKit

class RingLayer : CALayer {
  private let backgroundLayer = CAShapeLayer()
  private let foregroundLayer = CAShapeLayer()
  private let shadowLayer     = CAShapeLayer()
  private let shadowMaskLayer = CAShapeLayer()
  
  var ringWidth: CGFloat = 20.0 {
    didSet {
      prepareSubLayers()
    }
  }
  var proportionComplete: CGFloat = 0.7 {
    didSet {
      prepareSubLayers()
    }
  }
  var ringColor: CGColorRef = UIColor.redColor().CGColor {
    didSet {
      foregroundLayer.strokeColor = ringColor
    }
  }
  var ringBackgroundColor: CGColorRef = UIColor.darkGrayColor().CGColor {
    didSet {
      backgroundLayer.strokeColor = ringBackgroundColor
    }
  }
  
  override func layoutSublayers() {
    super.layoutSublayers()
    prepareSubLayers()
  }
  
  private func prepareSubLayers() {
    // Prepare some useful constants
    let center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
    let radius = (min(bounds.width, bounds.height) - ringWidth) / 2.0
    let startAngle = CGFloat(-M_PI_2)
    let endAngle = CGFloat(proportionComplete * 2.0 * CGFloat(M_PI) + startAngle)
    
    for layer in [backgroundLayer, foregroundLayer, shadowLayer, shadowMaskLayer] {
      layer.bounds = bounds
      layer.position = center
      layer.lineCap = kCALineCapRound
    }
    
    // Add them to the hierarchy
    for layer in [backgroundLayer, foregroundLayer, shadowLayer] {
      if layer.superlayer == nil {
        addSublayer(layer)
      }
    }
    
    // Prepare the paths
    let backgroundPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: startAngle + CGFloat(2.0 * M_PI), clockwise: true)
    let foregroundPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    let ringTipPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: endAngle - CGFloat(M_PI_4), endAngle: endAngle, clockwise: true)
    let shadowMaskPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: endAngle - CGFloat(M_PI_4), endAngle: endAngle + CGFloat(M_PI_4), clockwise: true)
    
    let cgRingTipPath = CGPathCreateCopyByStrokingPath(ringTipPath.CGPath, nil, ringWidth, kCGLineCapRound, kCGLineJoinRound, 10.0)
    let cgShadowMaskPath = CGPathCreateCopyByStrokingPath(shadowMaskPath.CGPath, nil, ringWidth, kCGLineCapRound, kCGLineJoinRound, 10.0)
    let completedShadowPath = CGPathCreateMutable()
    CGPathAddPath(completedShadowPath, nil, cgRingTipPath)
    CGPathAddPath(completedShadowPath, nil, cgShadowMaskPath)
    
    // Prepare the layers
    backgroundLayer.path = backgroundPath.CGPath
    backgroundLayer.strokeColor = ringBackgroundColor
    backgroundLayer.lineWidth = ringWidth
    backgroundLayer.fillColor = nil
    
    foregroundLayer.path = foregroundPath.CGPath
    foregroundLayer.strokeColor = ringColor
    foregroundLayer.lineWidth = ringWidth
    foregroundLayer.fillColor = nil
    
    shadowMaskLayer.path = completedShadowPath
    shadowMaskLayer.strokeColor = nil
    shadowMaskLayer.fillColor = UIColor.blackColor().CGColor
    shadowMaskLayer.fillRule = kCAFillRuleEvenOdd
    
    shadowLayer.path = ringTipPath.CGPath
    shadowLayer.fillColor = nil
    shadowLayer.strokeColor = UIColor.blackColor().CGColor
    shadowLayer.lineWidth = ringWidth
    shadowLayer.shadowColor = UIColor.blackColor().CGColor
    shadowLayer.shadowOffset = CGSize.zeroSize
    shadowLayer.shadowRadius = 5.0
    shadowLayer.shadowOpacity = 1.0
    shadowLayer.mask = shadowMaskLayer
    
  }
}


class ThreeRingView : UIView {
  
  let rings = [RingLayer(), RingLayer(), RingLayer()]
  let colours = [UIColor(red: 251.0/255.0, green: 12/255.0, blue: 116/255.0, alpha: 1.0),
                 UIColor(red: 158/255.0, green: 255/255.0, blue: 9/255.0, alpha: 1.0),
                 UIColor(red: 33/255.0, green: 249/255.0, blue: 198/255.0, alpha: 1.0)]
  let propFilled: [CGFloat] = [1.75, 1.15, 0.35]
  let ringWidth: CGFloat = 20.0
  let ringPadding: CGFloat = 4.0
  
  override func layoutSubviews() {
    super.layoutSubviews()
    backgroundColor = UIColor.blackColor()
    drawLayers()
  }
  
  private func drawLayers() {
    let size = min(bounds.width, bounds.height)
    for ringIdx in 0 ..< rings.count {
      // Sort sizes
      let ring = rings[ringIdx]
      let curSize = size - CGFloat(ringIdx) * ( ringWidth + ringPadding ) * 2.0
      ring.bounds = CGRect(x: 0, y: 0, width: curSize, height: curSize)
      ring.position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
      if ring.superlayer == nil {
        layer.addSublayer(ring)
      }
      
      // Apply colors and values
      ring.ringBackgroundColor = UIColor(white: 0.15, alpha: 1.0).CGColor
      ring.ringColor = colours[ringIdx].CGColor
      ring.ringWidth = ringWidth
      ring.proportionComplete = propFilled[ringIdx]
    }
  }
}


let view = ThreeRingView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))



