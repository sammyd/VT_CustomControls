import UIKit

public class RingLayer : CALayer {
  
  private let angleOffsetForZero = CGFloat(-M_PI_2)
  private lazy var gradientLayer : CircularGradientLayer = {
    let gradLayer = CircularGradientLayer()
    gradLayer.colors = self.ringColors
    return gradLayer
    }()
  
  private lazy var backgroundLayer : CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.strokeColor = self.ringBackgroundColor
    layer.lineWidth = self.ringWidth
    layer.fillColor = nil
    return layer
    }()
  
  private lazy var foregroundLayer : CALayer = {
    let layer = CALayer()
    layer.addSublayer(self.gradientLayer)
    layer.mask = self.foregroundMask
    return layer
    }()
  
  private lazy var ringTipLayer : RingTip = {
    let layer = RingTip()
    layer.color = self.ringColors.0
    layer.ringWidth = self.ringWidth
    return layer
    }()
  
  private lazy var foregroundMask : CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.strokeColor = UIColor.blackColor().CGColor
    layer.fillColor = UIColor.clearColor().CGColor
    layer.lineWidth = self.ringWidth
    layer.lineCap = kCALineCapRound
    return layer
    }()
  
  
  //:- Public API
  public var ringWidth: CGFloat = 40.0 {
    didSet {
      backgroundLayer.lineWidth = ringWidth
      ringTipLayer.ringWidth = ringWidth
      foregroundMask.lineWidth = ringWidth
      preparePaths()
    }
  }
  public var value: CGFloat = 0.0 {
    didSet {
      preparePaths()
      ringTipLayer.setValue(angleForValue(value), forKeyPath: "transform.rotation.z")
      gradientLayer.setValue(angleForValue(value), forKeyPath: "transform.rotation.z")
    }
  }
  public var ringColors: (CGColorRef, CGColorRef) = (UIColor.redColor().CGColor, UIColor.redColor().darkerColor.CGColor) {
    didSet {
      gradientLayer.colors = ringColors
      ringTipLayer.color = ringColors.0
    }
  }
  public var ringBackgroundColor: CGColorRef = UIColor.darkGrayColor().CGColor {
    didSet {
      backgroundLayer.strokeColor = ringBackgroundColor
    }
  }
  
  //:- Initialisation
  public override init() {
    super.init()
    sharedInitialization()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    sharedInitialization()
  }
}

extension RingLayer {
  private func sharedInitialization() {
    backgroundColor = UIColor.blackColor().CGColor
    [backgroundLayer, foregroundLayer, ringTipLayer].forEach { self.addSublayer($0) }
    self.value = 0.8
  }
  
  public override func layoutSublayers() {
    super.layoutSublayers()
    if backgroundLayer.bounds != bounds {
      for layer in [backgroundLayer, foregroundLayer, foregroundMask, gradientLayer, ringTipLayer] {
        layer.bounds = bounds
        layer.position = center
      }
      preparePaths()
    }
  }
}

extension RingLayer {
  private var radius : CGFloat {
    return (min(bounds.width, bounds.height) - ringWidth) / 2.0
  }
  
  private func preparePaths() {
    backgroundLayer.path = backgroundPath
    foregroundMask.path = maskPathForValue(value)
  }
  
  private var backgroundPath : CGPathRef {
    return UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * CGFloat(M_PI), clockwise: true).CGPath
  }
  
  private func maskPathForValue(value: CGFloat) -> CGPathRef {
    return UIBezierPath(arcCenter: center, radius: radius, startAngle: angleOffsetForZero, endAngle: angleForValue(value), clockwise: true).CGPath
  }
  
  private func angleForValue(value: CGFloat) -> CGFloat {
    return value * 2 * CGFloat(M_PI) + angleOffsetForZero
  }
}