//
//  RotationAnimation.swift
//  HealthRings
//
//  Created by Sam Davies on 12/06/2015.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

func rotationForLayer(layer: CALayer, byAngle angle: CGFloat) -> CAKeyframeAnimation {
  let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
  
  let c = layer.valueForKeyPath("transform.rotation.z")
  let currentAngle = c as? CGFloat ?? 0
  
  let numberOfKeyFrames = Int(floor(abs(angle) / CGFloat(M_PI_4)) + 2)

  var times = [CGFloat]()
  var values = [CGFloat]()
  
  for i in 0 ... abs(numberOfKeyFrames) {
    times.append(CGFloat(i) / CGFloat(numberOfKeyFrames))
    values.append(angle / CGFloat(numberOfKeyFrames) * CGFloat(i) + currentAngle)
  }
  
  animation.keyTimes = times
  animation.values = values
  
  return animation
}