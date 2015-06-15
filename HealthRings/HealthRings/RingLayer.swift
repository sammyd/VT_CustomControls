//
//  RingLayer.swift
//  HealthRings
//
//  Created by Sam Davies on 12/06/2015.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import UIKit


class RingLayer : CALayer {
  private let backgroundLayer = CAShapeLayer()
  private lazy var gradientLayer : CircularGradientLayer = {
    let gradLayer = CircularGradientLayer()
    gradLayer.setValue(M_PI, forKeyPath: "transform.rotation.z")
    return gradLayer
  }()
  private let tipLayer = CAShapeLayer()
  private let foregroundLayer = CALayer()
  private let foregroundMaskLayer = CAShapeLayer()
  private let shadowLayer     = CAShapeLayer()
  private let shadowMaskLayer = CAShapeLayer()
  
  var ringWidth: CGFloat = 20.0 {
    didSet {
      prepareSubLayers()
    }
  }
  var proportionComplete: CGFloat = 0.7 {
    didSet {
      // Need to animate this change
      animateFromProportion(oldValue, toProportion: proportionComplete)
    }
  }
  var ringColors: (CGColorRef, CGColorRef) = (UIColor.redColor().CGColor, UIColor.blackColor().CGColor) {
    didSet {
      gradientLayer.colours = ringColors
      tipLayer.strokeColor = ringColors.0
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
    
    for layer in [gradientLayer, tipLayer, backgroundLayer, foregroundLayer, foregroundMaskLayer, shadowLayer, shadowMaskLayer] {
      layer.bounds = bounds
      layer.position = center
    }
    
    // Add them to the hierarchy
    for layer in [backgroundLayer, foregroundLayer, shadowLayer] {
      if layer.superlayer == nil {
        addSublayer(layer)
      }
    }
    
    if proportionComplete < 0.02 {
      foregroundLayer.removeFromSuperlayer()
      shadowLayer.removeFromSuperlayer()
      return
    }
    
    // Prepare the paths
    let backgroundPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: startAngle + CGFloat(2.0 * M_PI), clockwise: true)
    let foregroundPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    let ringTipPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -0.1, endAngle: 0, clockwise: true)
    let shadowMaskPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -0.1, endAngle: 0.5, clockwise: true)
    
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
    
    tipLayer.path = ringTipPath.CGPath
    tipLayer.lineCap = kCALineCapRound
    tipLayer.strokeColor = ringColors.0
    tipLayer.lineWidth = ringWidth
    tipLayer.fillColor = nil
    
    //foregroundMaskLayer.path = foregroundPath.CGPath
    foregroundMaskLayer.lineCap = kCALineCapRound
    foregroundMaskLayer.lineWidth = ringWidth
    foregroundMaskLayer.fillColor = nil
    foregroundMaskLayer.strokeColor = UIColor.blackColor().CGColor
    
    foregroundLayer.mask = foregroundMaskLayer
    foregroundLayer.addSublayer(gradientLayer)
    foregroundLayer.addSublayer(tipLayer)
    gradientLayer.colours = ringColors
    
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
    shadowLayer.shadowRadius = 12.0
    shadowLayer.shadowOpacity = 1.0
    shadowLayer.lineCap = kCALineCapRound
    shadowLayer.mask = shadowMaskLayer
  }
  
  func animateFromProportion(fromProportion: CGFloat, toProportion: CGFloat) {
    let startAngle = CGFloat(fromProportion * 2.0 * CGFloat(M_PI) + CGFloat(-M_PI_2))
    let endAngle = CGFloat(toProportion * 2.0 * CGFloat(M_PI) + CGFloat(-M_PI_2))
    let angleDiff = endAngle - startAngle
    
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    CATransaction.setAnimationDuration(5.0)
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    
    tipLayer.addAnimation(rotationForLayer(tipLayer, byAngle: angleDiff), forKey: "transform.rotation.z")
    shadowLayer.addAnimation(rotationForLayer(shadowLayer, byAngle: angleDiff), forKey: "transform.rotation.z")
    gradientLayer.addAnimation(rotationForLayer(gradientLayer, byAngle: angleDiff), forKey: "transform.rotation.z")
    
    tipLayer.transform = CATransform3DMakeRotation(endAngle, 0, 0, 1)
    shadowLayer.transform = CATransform3DMakeRotation(endAngle, 0, 0, 1)
    gradientLayer.transform = CATransform3DMakeRotation(endAngle + CGFloat(M_PI), 0, 0, 1)
    
    // Change the path
    let center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
    let radius = (min(bounds.width, bounds.height) - ringWidth) / 2.0
    
    let foregroundPath : UIBezierPath
    let preAnimStrokeEnd : CGFloat
    let postAnimStrokeEnd : CGFloat
    if angleDiff > 0 {
      foregroundPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(-M_PI_2), endAngle: endAngle, clockwise: true)
      foregroundMaskLayer.path = foregroundPath.CGPath
      postAnimStrokeEnd = 1.0
      preAnimStrokeEnd = fromProportion / toProportion
    } else {
      preAnimStrokeEnd = 1.0
      postAnimStrokeEnd = toProportion / fromProportion
      CATransaction.setCompletionBlock {
        let foregroundPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(-M_PI_2), endAngle: endAngle, clockwise: true)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.foregroundMaskLayer.path = foregroundPath.CGPath
        self.foregroundMaskLayer.strokeEnd = 1.0
        CATransaction.commit()
      }
    }
    
    foregroundMaskLayer.strokeEnd = postAnimStrokeEnd
    let strokeAnim = CABasicAnimation(keyPath: "strokeEnd")
    strokeAnim.fromValue = preAnimStrokeEnd
    strokeAnim.toValue = postAnimStrokeEnd
    foregroundMaskLayer.addAnimation(strokeAnim, forKey: "strokeEnd")
    
    CATransaction.commit()
  }
}
