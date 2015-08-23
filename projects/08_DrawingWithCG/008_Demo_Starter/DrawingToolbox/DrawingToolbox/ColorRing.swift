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
class ColorRing : UIView {
  
  private let numberSegments = 400
  
  @IBInspectable
  var ringWidth : CGFloat = 2.0 {
    didSet {
      setNeedsDisplay()
    }
  }
}

extension ColorRing {
  override func drawRect(rect: CGRect) {
    if let cxt = UIGraphicsGetCurrentContext() {
      drawRainbowWheel(cxt, rect: rect)
    }
  }
}

extension ColorRing {
  private func drawRainbowWheel(context: CGContextRef, rect: CGRect) {
    CGContextSaveGState(context)
    
    let ringRadius = (min(rect.width, rect.height) - ringWidth) / 2
    
    CGContextSetLineWidth(context, ringWidth)
    CGContextSetLineCap(context, .Butt)
    
    for segment in 0 ..< numberSegments {
      let proportion = CGFloat(segment) / CGFloat(numberSegments)
      let startAngle = proportion * 2 * CGFloat(M_PI)
      let endAngle = CGFloat(segment + 1) / CGFloat(numberSegments) * 2 * CGFloat(M_PI)
      
      UIColor(hue: proportion, saturation: 1.0, brightness: 1.0, alpha: 1.0).setStroke()
      CGContextAddArc(context, rect.midX, rect.midY, ringRadius, startAngle, endAngle, 0)
      CGContextStrokePath(context)
    }
    
    CGContextRestoreGState(context)
  }
}
