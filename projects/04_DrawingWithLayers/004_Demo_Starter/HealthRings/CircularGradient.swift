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

import CoreImage
import UIKit


private class CircularGradientFilter : CIFilter {
  
  private lazy var kernel: CIColorKernel  = {
    return self.createKernel()
  }()
  
  var outputSize: CGSize!
  var colours: (CIColor, CIColor)!
  
  override var outputImage : CIImage {
    let dod = CGRect(origin: CGPoint.zeroPoint, size: outputSize)
    let args = [ colours.0 as AnyObject, colours.1 as AnyObject, outputSize.width, outputSize.height]
    return kernel.applyWithExtent(dod, arguments: args)!
  }
  
  private func createKernel() -> CIColorKernel {
    let kernelString =
    "kernel vec4 chromaKey( __color c1, __color c2, float width, float height ) { \n" +
      "  vec2 pos = destCoord();\n" +
      "  float x = 2.0 * pos.x / width - 1.0;\n" +
      "  float y = 2.0 * pos.y / height - 1.0;\n" +
      "  float prop = atan(y, x) / (3.1415926535897932 * 2.0) + 0.5;\n" +
      "  return c1 * prop + c2 * (1.0 - prop);\n" +
    "}"
    return CIColorKernel(string: kernelString)!
  }
}



public class CircularGradientLayer : CALayer {
  private let gradientFilter = CircularGradientFilter()
  private let ciContext = CIContext(options: [ kCIContextUseSoftwareRenderer : false ])
  
  public override init() {
    super.init()
    needsDisplayOnBoundsChange = true
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    needsDisplayOnBoundsChange = true
  }
  
  override init(layer: AnyObject) {
    super.init(layer: layer)
    needsDisplayOnBoundsChange = true
    if let layer = layer as? CircularGradientLayer {
      colours = layer.colours
    }
  }
  
  var colours: (CGColorRef, CGColorRef) = (UIColor.whiteColor().CGColor, UIColor.blackColor().CGColor) {
    didSet {
      setNeedsDisplay()
    }
  }
  
  public override func drawInContext(ctx: CGContext) {
    super.drawInContext(ctx)
    gradientFilter.outputSize = bounds.size
    gradientFilter.colours = (CIColor(CGColor: colours.0), CIColor(CGColor: colours.1))
    let image = ciContext.createCGImage(gradientFilter.outputImage, fromRect: bounds)
    CGContextDrawImage(ctx, bounds, image)
  }
}

