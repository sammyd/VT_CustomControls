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
