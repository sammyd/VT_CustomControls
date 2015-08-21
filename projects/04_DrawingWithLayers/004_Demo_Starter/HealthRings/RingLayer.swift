//
//  RingLayer.swift
//  HealthRings
//
//  Created by Sam Davies on 12/06/2015.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import UIKit


class RingLayer : CALayer {

  private let angleOffsetForZero = CGFloat(-M_PI_2)
  

  //:- Public API
  var ringWidth: CGFloat = 20.0
  var value: CGFloat = 0.7
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
    
  }
}
