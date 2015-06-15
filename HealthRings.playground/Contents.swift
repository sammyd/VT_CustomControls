import UIKit
import CoreImage
import XCPlayground

let layer = CALayer()
layer.transform
layer.setValue(0.4, forKeyPath: "transform.rotation.z")
layer.transform
layer.valueForKeyPath("transform.rotation.z")


/*
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
  
  override init!(layer: AnyObject!) {
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
      // Need to animate this change
      animateToProportion(proportionComplete)
    }
  }
  var ringColors: (CGColorRef, CGColorRef) = (UIColor.redColor().CGColor, UIColor.blackColor().CGColor) {
    didSet {
      gradientLayer.colours = ringColors
      tipLayer.strokeColor = ringColors.0
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
    let ringTipPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -0.1, endAngle: 0, clockwise: true)
    let shadowMaskPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -0.1, endAngle: 0.5, clockwise: true)
    
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
    
    //foregroundMaskLayer.path = foregroundPath.CGPath
    foregroundMaskLayer.lineCap = kCALineCapRound
    foregroundMaskLayer.lineWidth = ringWidth
    foregroundMaskLayer.fillColor = nil
    foregroundMaskLayer.strokeColor = UIColor.blackColor().CGColor

    foregroundLayer.mask = foregroundMaskLayer
    foregroundLayer.addSublayer(gradientLayer)
    foregroundLayer.addSublayer(tipLayer)
    gradientLayer.colours = ringColors
    
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
  
  func animateToProportion(proportion: CGFloat) {
    let startAngle = CGFloat(-M_PI_2)
    let endAngle = CGFloat(proportion * 2.0 * CGFloat(M_PI) + startAngle)
    
    CATransaction.begin()
    CATransaction.setAnimationDuration(5.0)
    tipLayer.transform = CATransform3DMakeRotation(endAngle, 0, 0, 1)
    gradientLayer.transform = CATransform3DMakeRotation(endAngle + CGFloat(M_PI), 0, 0, 1)
    shadowLayer.transform = CATransform3DMakeRotation(endAngle, 0, 0, 1)
    CATransaction.begin()
    CATransaction.disableActions()
    // Change the path
    let center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
    let radius = (min(bounds.width, bounds.height) - ringWidth) / 2.0
    let foregroundPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    foregroundMaskLayer.path = foregroundPath.CGPath
    foregroundMaskLayer.strokeEnd = 0.5
    
    CATransaction.commit()
    
    foregroundMaskLayer.strokeEnd = 1.0
    
    CATransaction.commit()
  }
}

extension UIColor {
  var darkerColor : UIColor {
    var hue : CGFloat = 0.0
    var saturation : CGFloat = 0.0
    var brightness : CGFloat = 0.0
    var alpha : CGFloat = 0.0
    getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
    return UIColor(hue: min(hue * 1.1, 1.0), saturation: saturation, brightness: brightness * 0.7, alpha: alpha)
  }
}


class ThreeRingView : UIView {
  
  private let rings = [RingLayer(), RingLayer(), RingLayer()]
  
  var colors = [ UIColor(red: 251.0/255.0, green:  12.0/255.0, blue: 116.0/255.0, alpha: 1.0),
                 UIColor(red: 158.0/255.0, green: 255.0/255.0, blue:   9.0/255.0, alpha: 1.0),
                 UIColor(red:  33.0/255.0, green: 253.0/255.0, blue: 197.0/255.0, alpha: 1.0)  ] {
    didSet {
      applyRingColors()
    }
  }
  
  let ringBackgroundColor = UIColor(white: 0.15, alpha: 1.0)
  
  var propFilled: [CGFloat] = [1.75, 1.08, 1.35] {
    didSet {
      setRingProportions()
    }
  }
  
  var ringWidth: CGFloat = 30.0 {
    didSet {
      drawLayers()
    }
  }
  
  var ringPadding: CGFloat = 1.0 {
    didSet {
      drawLayers()
    }
  }
  
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
      
      // Check they
      if ring.superlayer == nil {
        layer.addSublayer(ring)
      }
      
      // Apply colors and values
      ring.ringBackgroundColor = ringBackgroundColor.CGColor
      ring.ringWidth = ringWidth
    }
    
    applyRingColors()
    setRingProportions()
  }
  
  private func applyRingColors() {
    for (ring, color) in zip(rings, colors) {
      ring.ringColors = (color.CGColor, color.darkerColor.CGColor)
    }
  }
  
  private func setRingProportions() {
    for (ring, proportion) in zip(rings, propFilled) {
      ring.proportionComplete = proportion
    }
  }
}


let view = ThreeRingView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))

XCPShowView("rings", view)

view.propFilled = [0.8, 1.2, 1.5]
*/




