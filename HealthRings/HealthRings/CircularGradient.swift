import CoreImage
import UIKit



public class CircularGradientFilter : CIFilter {
  
  private var kernel: CIColorKernel {
    return createKernel()
  }
  public var outputSize: CGSize!
  public var colours: (CIColor, CIColor)!
  
  override public var outputImage : CIImage {
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

