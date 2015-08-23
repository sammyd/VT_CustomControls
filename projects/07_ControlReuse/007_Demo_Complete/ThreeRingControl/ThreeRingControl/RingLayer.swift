import UIKit

class RingLayer : CALayer {
  
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
  var ringWidth: CGFloat = 40.0 {
    didSet {
      backgroundLayer.lineWidth = ringWidth
      ringTipLayer.ringWidth = ringWidth
      foregroundMask.lineWidth = ringWidth
      preparePaths()
    }
  }
  private var _value: CGFloat = 0.0
  var value: CGFloat {
    get {
      return _value
    }
    set(newValue) {
      setValue(newValue, animated: false)
    }
  }
  var ringColors: (CGColorRef, CGColorRef) = (UIColor.redColor().CGColor, UIColor.redColor().darkerColor.CGColor) {
    didSet {
      gradientLayer.colors = ringColors
      ringTipLayer.color = ringColors.0
    }
  }
  var ringBackgroundColor: CGColorRef = UIColor.darkGrayColor().CGColor {
    didSet {
      backgroundLayer.strokeColor = ringBackgroundColor
    }
  }
  
  //:- Initialisation
  override init() {
    super.init()
    sharedInitialization()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    sharedInitialization()
  }
  
  override init(layer: AnyObject) {
    super.init(layer: layer)
    if let layer = layer as? RingLayer {
      ringWidth = layer.ringWidth
      value = layer.value
      ringBackgroundColor = layer.ringBackgroundColor
      ringColors = layer.ringColors
    }
  }
}

extension RingLayer {
  private func sharedInitialization() {
    backgroundColor = UIColor.blackColor().CGColor
    [backgroundLayer, foregroundLayer, ringTipLayer].forEach { self.addSublayer($0) }
    self.value = 0.8
  }
  
  override func layoutSublayers() {
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

extension RingLayer {
  func setValue(value: CGFloat, animated: Bool = false) {
    if animated {
      animateFromValue(_value, toValue: value)
    } else {
      CATransaction.begin()
      CATransaction.setDisableActions(true)
      foregroundMask.path = maskPathForValue(value)
      ringTipLayer.setValue(angleForValue(value), forKeyPath: "transform.rotation.z")
      gradientLayer.setValue(angleForValue(value), forKeyPath: "transform.rotation.z")
      CATransaction.commit()
    }
    
    _value = value
  }
  
  private func animateFromValue(fromValue: CGFloat, toValue: CGFloat) {
    let angleDelta = (toValue - fromValue) * 2.0 * CGFloat(M_PI)
    if abs(angleDelta) < 0.001 {
      return
    }
    
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    
    // Rotate the tip and the gradient
    ringTipLayer.addAnimation(rotationForLayer(ringTipLayer, byAngle: angleDelta), forKey: "transform.rotation.z")
    gradientLayer.addAnimation(rotationForLayer(gradientLayer, byAngle: angleDelta), forKey: "transform.rotation.z")
    // Update model
    ringTipLayer.setValue(angleForValue(toValue), forKeyPath: "transform.rotation.z")
    gradientLayer.setValue(angleForValue(toValue), forKeyPath: "transform.rotation.z")
    
    // Update the foreground mask path
    let finalMaskPath = maskPathForValue(toValue)
    let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
    if angleDelta > 0 {
      // Need to grow the mask. Immediately create the larger path and animate strokeEnd to fill it
      foregroundMask.path = finalMaskPath
      strokeAnimation.fromValue = fromValue / toValue
      strokeAnimation.toValue = 1.0
    } else {
      // Mask needs to shrink. Animate down and replace mask at end of transaction
      strokeAnimation.fromValue = 1.0
      strokeAnimation.toValue = toValue / fromValue
      CATransaction.setCompletionBlock {
        // Update the mask to the new shape after the animation
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.foregroundMask.path = finalMaskPath
        self.foregroundMask.strokeEnd = 1.0
        CATransaction.commit()
      }
    }
    foregroundMask.addAnimation(strokeAnimation, forKey: "strokeEnd")
    
    CATransaction.commit()
  }
}






