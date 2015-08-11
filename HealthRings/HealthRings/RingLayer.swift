//
//  RingLayer.swift
//  HealthRings
//
//  Created by Sam Davies on 12/06/2015.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import UIKit


class RingLayer : CALayer {
  //:- Private sublayer properties
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
  
  private let tipLayer = ShadowTip()
  
  private lazy var foregroundLayer : CALayer = {
    let layer = CALayer()
    layer.mask = self.foregroundMaskLayer
    layer.addSublayer(self.gradientLayer)
    layer.addSublayer(self.tipLayer)
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
  
  //:- Utility Properties
  private var radius : CGFloat {
    return (min(bounds.width, bounds.height) - ringWidth) / 2.0
  }
  
  private let angleOffsetForZero = CGFloat(-M_PI_2)
  
  private var backgroundRingPath : CGPathRef {
    return UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(2.0 * M_PI), clockwise: true).CGPath
  }

  //:- Public API
  var ringWidth: CGFloat = 20.0 {
    didSet {
      tipLayer.ringWidth = ringWidth
      backgroundLayer.lineWidth = ringWidth
      foregroundMaskLayer.lineWidth = ringWidth
      preparePaths()
    }
  }
  var value: CGFloat = 0.7 {
    didSet {
      // Need to animate this change
      changeValueFrom(oldValue, toValue: value, animated: animationEnabled)
    }
  }
  var ringColors: (CGColorRef, CGColorRef) = (UIColor.redColor().CGColor, UIColor.blackColor().CGColor) {
    didSet {
      gradientLayer.colours = ringColors
      tipLayer.color = ringColors.0
    }
  }
  var ringBackgroundColor: CGColorRef = UIColor.darkGrayColor().CGColor {
    didSet {
      backgroundLayer.strokeColor = ringBackgroundColor
    }
  }
  var animationEnabled = true
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
      animationEnabled = layer.animationEnabled
      animationDuration = layer.animationDuration
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    sharedInitialization()
  }
  
  private func sharedInitialization() {
    // Add the sublayers to the hierarchy
    for layer in [backgroundLayer, foregroundLayer, tipLayer] {
      addSublayer(layer)
    }
  }
  
  //:- Lifecycle overrides
  override func layoutSublayers() {
    super.layoutSublayers()
    if gradientLayer.bounds != bounds {
      // Resize the sublayers
      for layer in [gradientLayer, tipLayer, backgroundLayer, foregroundLayer, foregroundMaskLayer] {
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
  
  private func changeValueFrom(fromValue: CGFloat, toValue: CGFloat, animated: Bool = true) {
    guard abs(fromValue - toValue) > 0.01 else { return }
    
    let toAngle = CGFloat(toValue * 2.0 * CGFloat(M_PI) + angleOffsetForZero)
    let angleDelta = CGFloat((toValue - fromValue) * 2.0 * CGFloat(M_PI))
    
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    if animated {
      CATransaction.setAnimationDuration(animationDuration)
    }
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    
    // Rotate the tip and the gradient
    if animated {
      tipLayer.addAnimation(rotationForLayer(tipLayer, byAngle: angleDelta), forKey: "transform.rotation.z")
      gradientLayer.addAnimation(rotationForLayer(gradientLayer, byAngle: angleDelta), forKey: "transform.rotation.z")
    }
    // Update model
    tipLayer.transform = CATransform3DMakeRotation(toAngle, 0, 0, 1)
    gradientLayer.transform = CATransform3DMakeRotation(toAngle + CGFloat(M_PI), 0, 0, 1)

    // Update the foreground mask path
    let finalMaskPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: angleOffsetForZero, endAngle: toAngle, clockwise: true)
    if !animated {
      foregroundMaskLayer.path = finalMaskPath.CGPath
    } else {
      let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
      if angleDelta > 0 {
        // Need to grow the mask. Immediately create the larger path and animate strokeEnd to fill it
        foregroundMaskLayer.path = finalMaskPath.CGPath
        strokeAnimation.fromValue = fromValue / toValue
        strokeAnimation.toValue = 1.0
      } else {
        // Mask needs to shrink. Animate down and replace mask at end of transaction
        strokeAnimation.fromValue = 1.0
        strokeAnimation.toValue = toValue / fromValue
        CATransaction.setCompletionBlock {
          // Update the mask to the new shape after the animation
          CATransaction.begin()
          CATransaction.setDisableActions(true)
          self.foregroundMaskLayer.path = finalMaskPath.CGPath
          self.foregroundMaskLayer.strokeEnd = 1.0
          CATransaction.commit()
        }
      }
      foregroundMaskLayer.addAnimation(strokeAnimation, forKey: "strokeEnd")
    }
    
    CATransaction.commit()
  }
}
