import UIKit
import XCPlayground



class ShadowTip : CALayer {
  
  //:- Constituent Layers
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
  
  //:- Utility Properties
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
  
  //:- API Properties
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
  
  //: Initialisation
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
  
  //: Lifecycle Overrides
  override func layoutSublayers() {
    for layer in [tipLayer, shadowLayer, shadowMaskLayer] {
      layer.bounds = bounds
      layer.position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
    }
    preparePaths()
  }

  //: Utility methods
  private func preparePaths() {
    tipLayer.path = tipPath
    shadowLayer.path = tipPath
    shadowMaskLayer.path = shadowMaskPath
  }
}


let l = ShadowTip()
let v = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
l.bounds = v.bounds
l.position = CGPoint(x: v.bounds.width / 2.0, y: v.bounds.height / 2.0)
v.layer.addSublayer(l)
v.backgroundColor = UIColor.whiteColor()
l.color = UIColor.greenColor().CGColor
l.ringWidth = 40
l.bounds = CGRect(x: 0, y: 0, width: 150, height: 150)

v



