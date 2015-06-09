import UIKit
import CoreImage

public class CircularGradientFilter : CIFilter {
  
  private var kernel: CIColorKernel {
    return createKernel()
  }
  public var outputSize: CGSize!
  public var colours: (CIColor, CIColor)!
  
  override public var outputImage : CIImage! {
    let dod = CGRect(origin: CGPoint.zeroPoint, size: outputSize)
    let args = [ colours.0 as AnyObject, colours.1 as AnyObject, outputSize.width, outputSize.height]
    return kernel.applyWithExtent(dod, arguments: args)
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
    return CIColorKernel(string: kernelString)
  }
}

public class CircularGradientLayer : CALayer {
  private let gradientFilter = CircularGradientFilter()
  private let ciContext = CIContext(options: [ kCIContextUseSoftwareRenderer : false ])
  
  public override init!() {
    super.init()
    needsDisplayOnBoundsChange = true
  }
  
  public required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    needsDisplayOnBoundsChange = true
  }
  
  var colours: (CGColorRef, CGColorRef) = (UIColor.whiteColor().CGColor, UIColor.blackColor().CGColor) {
    didSet {
      setNeedsDisplay()
    }
  }
  
  public override func drawInContext(ctx: CGContext!) {
    super.drawInContext(ctx)
    gradientFilter.outputSize = bounds.size
    gradientFilter.colours = (CIColor(CGColor: colours.0), CIColor(CGColor: colours.1))
    let image = ciContext.createCGImage(gradientFilter.outputImage, fromRect: bounds)
    CGContextDrawImage(ctx, bounds, image)
  }
}

class RingLayer : CALayer {
  private let backgroundLayer = CAShapeLayer()
  private let gradientLayer = CircularGradientLayer()
  private let tipLayer = CAShapeLayer()
  private let foregroundLayer = CALayer()
  private let foregroundMaskLayer = CAShapeLayer()
  private let shadowLayer     = CAShapeLayer()
  private let shadowMaskLayer = CAShapeLayer()
  
  var ringWidth: CGFloat = 20.0 {
    didSet {
      prepareSubLayers()
    }
  }
  var proportionComplete: CGFloat = 0.7 {
    didSet {
      prepareSubLayers()
    }
  }
  var ringColors: (CGColorRef, CGColorRef) = (UIColor.redColor().CGColor, UIColor.blackColor().CGColor) {
    didSet {
      gradientLayer.colours = ringColors
    }
  }
  var ringBackgroundColor: CGColorRef = UIColor.darkGrayColor().CGColor {
    didSet {
      backgroundLayer.strokeColor = ringBackgroundColor
    }
  }
  
  override func layoutSublayers() {
    super.layoutSublayers()
    prepareSubLayers()
  }
  
  private func prepareSubLayers() {
    // Prepare some useful constants
    let center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
    let radius = (min(bounds.width, bounds.height) - ringWidth) / 2.0
    let startAngle = CGFloat(-M_PI_2)
    let endAngle = CGFloat(proportionComplete * 2.0 * CGFloat(M_PI) + startAngle)
    
    for layer in [gradientLayer, tipLayer, backgroundLayer, foregroundLayer, foregroundMaskLayer, shadowLayer, shadowMaskLayer] {
      layer.bounds = bounds
      layer.position = center
    }
    
    // Add them to the hierarchy
    for layer in [backgroundLayer, foregroundLayer, shadowLayer] {
      if layer.superlayer == nil {
        addSublayer(layer)
      }
    }
    
    if proportionComplete < 0.02 {
      foregroundLayer.removeFromSuperlayer()
      shadowLayer.removeFromSuperlayer()
      return
    }
    
    // Prepare the paths
    let backgroundPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: startAngle + CGFloat(2.0 * M_PI), clockwise: true)
    let foregroundPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    let ringTipPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: endAngle - 0.1, endAngle: endAngle, clockwise: true)
    let shadowMaskPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: endAngle - 0.1, endAngle: endAngle + CGFloat(M_PI_4), clockwise: true)
    
    let cgRingTipPath = CGPathCreateCopyByStrokingPath(ringTipPath.CGPath, nil, ringWidth, kCGLineCapRound, kCGLineJoinRound, 10.0)
    let cgShadowMaskPath = CGPathCreateCopyByStrokingPath(shadowMaskPath.CGPath, nil, ringWidth, kCGLineCapRound, kCGLineJoinRound, 10.0)
    let completedShadowPath = CGPathCreateMutable()
    CGPathAddPath(completedShadowPath, nil, cgRingTipPath)
    CGPathAddPath(completedShadowPath, nil, cgShadowMaskPath)
    
    // Prepare the layers
    backgroundLayer.path = backgroundPath.CGPath
    backgroundLayer.strokeColor = ringBackgroundColor
    backgroundLayer.lineWidth = ringWidth
    backgroundLayer.fillColor = nil
    
    tipLayer.path = ringTipPath.CGPath
    tipLayer.lineCap = kCALineCapRound
    tipLayer.strokeColor = ringColors.0
    tipLayer.lineWidth = ringWidth
    tipLayer.fillColor = nil
    
    foregroundMaskLayer.path = foregroundPath.CGPath
    foregroundMaskLayer.lineCap = kCALineCapRound
    foregroundMaskLayer.lineWidth = ringWidth
    foregroundMaskLayer.fillColor = nil
    foregroundMaskLayer.strokeColor = UIColor.blackColor().CGColor
    
    foregroundLayer.mask = foregroundMaskLayer
    foregroundLayer.addSublayer(gradientLayer)
    foregroundLayer.addSublayer(tipLayer)
    gradientLayer.colours = ringColors
    // Need to rotate it
    gradientLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(endAngle + CGFloat(M_PI)))
    
    shadowMaskLayer.path = completedShadowPath
    shadowMaskLayer.strokeColor = nil
    shadowMaskLayer.fillColor = UIColor.blackColor().CGColor
    shadowMaskLayer.fillRule = kCAFillRuleEvenOdd
    
    shadowLayer.path = ringTipPath.CGPath
    shadowLayer.fillColor = nil
    shadowLayer.strokeColor = UIColor.blackColor().CGColor
    shadowLayer.lineWidth = ringWidth
    shadowLayer.shadowColor = UIColor.blackColor().CGColor
    shadowLayer.shadowOffset = CGSize.zeroSize
    shadowLayer.shadowRadius = 12.0
    shadowLayer.shadowOpacity = 1.0
    shadowLayer.lineCap = kCALineCapRound
    shadowLayer.mask = shadowMaskLayer
  }
}


class ThreeRingView : UIView {
  
  let rings = [RingLayer(), RingLayer(), RingLayer()]
  let colours = [(UIColor(red: 251.0/255.0, green: 12/255.0, blue: 116/255.0, alpha: 1.0), UIColor(red: 200/255.0, green: 0, blue: 32/225.0, alpha: 1.0)),
                 (UIColor(red: 158/255.0, green: 255/255.0, blue: 9/255.0, alpha: 1.0),    UIColor(red: 80/255.0, green: 200/255.0, blue: 4/255.0, alpha: 1.0)),
                 (UIColor(red: 33/255.0, green: 253/255.0, blue: 197/255.0, alpha: 1.0),   UIColor(red: 15/255.0, green: 160/255.0, blue: 180/255.0, alpha: 1.0))]
  let propFilled: [CGFloat] = [1.75, 0.08, 1.35]
  let ringWidth: CGFloat = 30.0
  let ringPadding: CGFloat = 2.0
  
  override func layoutSubviews() {
    super.layoutSubviews()
    backgroundColor = UIColor.blackColor()
    drawLayers()
  }
  
  private func drawLayers() {
    let size = min(bounds.width, bounds.height)
    for ringIdx in 0 ..< rings.count {
      // Sort sizes
      let ring = rings[ringIdx]
      let curSize = size - CGFloat(ringIdx) * ( ringWidth + ringPadding ) * 2.0
      ring.bounds = CGRect(x: 0, y: 0, width: curSize, height: curSize)
      ring.position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
      if ring.superlayer == nil {
        layer.addSublayer(ring)
      }
      
      // Apply colors and values
      ring.ringBackgroundColor = UIColor(white: 0.15, alpha: 1.0).CGColor
      ring.ringColors = (colours[ringIdx].0.CGColor, colours[ringIdx].1.CGColor)
      ring.ringWidth = ringWidth
      ring.proportionComplete = propFilled[ringIdx]
    }
  }
}


let view = ThreeRingView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
