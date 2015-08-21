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

@IBDesignable
class ThreeRingView : UIView {
  
  private let rings = [RingLayer(), RingLayer(), RingLayer()]
  
  let ringBackgroundColor = UIColor(white: 0.15, alpha: 1.0)
  let ringWidth: CGFloat = 30.0
  let ringPadding: CGFloat = 1.0
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    sharedInitialization()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    sharedInitialization()
  }
  
  // MARK:- Ring values
  @IBInspectable
  var valueInnerRing : CGFloat = 0.0
  
  @IBInspectable
  var valueMiddleRing : CGFloat = 0.0
  
  @IBInspectable
  var valueOuterRing : CGFloat = 0.0
}

// MARK:- Ring colors
extension ThreeRingView {
  @IBInspectable
  var colorInnerRing : UIColor {
    set(newColor) {
      setColor(newColor, ofRing: rings[2])
    }
    get {
      return UIColor(CGColor: rings[2].ringColors.0)
    }
  }
  
  @IBInspectable
  var colorMiddleRing : UIColor {
    set(newColor) {
      setColor(newColor, ofRing: rings[1])
    }
    get {
      return UIColor(CGColor: rings[1].ringColors.0)
    }
  }
  
  @IBInspectable
  var colorOuterRing : UIColor {
    set(newColor) {
      setColor(newColor, ofRing: rings[0])
    }
    get {
      return UIColor(CGColor: rings[0].ringColors.0)
    }
  }
  
  private func setColor(color: UIColor, ofRing ring: RingLayer) {
    ring.ringColors = (color.CGColor, color.darkerColor.CGColor)
  }
}


// MARK:- Layout
extension ThreeRingView {
  private func sharedInitialization() {
    for ring in rings {
      layer.addSublayer(ring)
      ring.ringBackgroundColor = ringBackgroundColor.CGColor
      ring.ringWidth = ringWidth
    }
    
    // Set the default values
    for (color, ring) in zip([UIColor.hrPinkColor, UIColor.hrGreenColor, UIColor.hrBlueColor], rings) {
      setColor(color, ofRing: ring)
      ring.value = 0.0
    }
  }
}

