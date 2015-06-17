import UIKit

class ShadowTip : CALayer {
  
  //MARK:- Constituent Layers
  private lazy var tipLayer : CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.lineCap = kCALineCapRound
    return layer
    }()
  
  private lazy var shadowLayer : CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.lineCap = kCALineCapRound
    layer.strokeColor = UIColor.blackColor().CGColor
    layer.shadowColor = UIColor.blackColor().CGColor
    layer.shadowOffset = CGSize.zeroSize
    layer.shadowRadius = 12.0
    layer.shadowOpacity = 1.0
    layer.mask = self.shadowMaskLayer
    return layer
    }()
  
  private lazy var shadowMaskLayer : CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.strokeColor = UIColor.blackColor().CGColor
    layer.lineCap = kCALineCapButt
    return layer
    }()
  
  //MARK:- Utility Properties
  private var center : CGPoint {
    return CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
  }
  
  private var radius : CGFloat {
    return (min(bounds.width, bounds.height) - ringWidth) / 2.0
  }
  
  private var shadowMaskPath : CGPathRef {
    return UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(M_PI_2), clockwise: true).CGPath
  }
  
  private var tipPath : CGPathRef {
    return UIBezierPath(arcCenter: center, radius: radius, startAngle: -0.01, endAngle: 0, clockwise: true).CGPath
  }
  
  //MARK:- API Properties
  var color: CGColorRef = UIColor.redColor().CGColor {
    didSet {
      tipLayer.strokeColor = color
    }
  }
  
  var ringWidth: CGFloat = 20.0 {
    didSet {
      tipLayer.lineWidth = ringWidth
      shadowLayer.lineWidth = ringWidth
      shadowMaskLayer.lineWidth = ringWidth
      preparePaths()
    }
  }
  
  //MARK:- Initialisation
  override init() {
    super.init()
    sharedInitialisation()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    sharedInitialisation()
  }
  
  private func sharedInitialisation() {
    addSublayer(shadowLayer)
    addSublayer(tipLayer)
    color = UIColor.redColor().CGColor
    ringWidth = 20.0
  }
  
  //MARK:- Lifecycle Overrides
  override func layoutSublayers() {
    for layer in [tipLayer, shadowLayer, shadowMaskLayer] {
      layer.bounds = bounds
      layer.position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
    }
    preparePaths()
  }
  
  //MARK:- Utility methods
  private func preparePaths() {
    tipLayer.path = tipPath
    shadowLayer.path = tipPath
    shadowMaskLayer.path = shadowMaskPath
  }
}
