//
//  SingleFingerRotation.swift
//  SketchPad
//
//  Created by Sam Davies on 15/08/2015.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class AngleGestureRecognizer : UIPanGestureRecognizer {
  
  private var gestureStartAngle : CGFloat?
  var touchAngle : CGFloat = 0.0
  var angleDelta : CGFloat {
    guard let gestureStartAngle = gestureStartAngle else {
      return 0
    }
    return touchAngle - gestureStartAngle
  }
  
  override init(target: AnyObject?, action: Selector) {
    super.init(target: target, action: action)
    
    maximumNumberOfTouches = 1
    minimumNumberOfTouches = 1
  }
  
}


extension AngleGestureRecognizer {
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
    super.touchesBegan(touches, withEvent: event)
    updateTouchAngleWithTouches(touches)
    gestureStartAngle = touchAngle
  }
  
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
    super.touchesMoved(touches, withEvent: event)
    updateTouchAngleWithTouches(touches)
  }
  
  override func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent) {
    super.touchesCancelled(touches, withEvent: event)
    touchAngle = 0
    gestureStartAngle = .None
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
    super.touchesEnded(touches, withEvent: event)
    touchAngle = 0
    gestureStartAngle = .None
  }
  
  
  private func updateTouchAngleWithTouches(touches: Set<UITouch>) {
    if let touchPoint = touches.first?.locationInView(view) {
      touchAngle = calculateAngleToPoint(touchPoint)
    }
  }
  
  private func calculateAngleToPoint(point: CGPoint) -> CGFloat {
    guard let bounds = view?.bounds else {
      return 0
    }
    
    let centerOffset = CGPoint(x: point.x - bounds.midX,
                               y: point.y - bounds.midY)
    return atan2(centerOffset.y, centerOffset.x)
  }
}
