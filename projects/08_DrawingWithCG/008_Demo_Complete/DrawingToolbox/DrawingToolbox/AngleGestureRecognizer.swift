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
