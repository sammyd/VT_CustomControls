import UIKit
import XCPlayground



class RingTip : CALayer {
  
  //MARK:- Constituent Layers
  private lazy var tipLayer : CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.lineCap = kCALineCapRound
    layer.lineWidth = self.ringWidth
    return layer
    }()
  
  //MARK:- Utility Properties
  private var radius : CGFloat {
    return (min(bounds.width, bounds.height) - ringWidth) / 2.0
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
  
  var ringWidth: CGFloat = 40.0 {
    didSet {
      tipLayer.lineWidth = ringWidth
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
    addSublayer(tipLayer)
    color = UIColor.redColor().CGColor
    preparePaths()
  }
  
  //MARK:- Lifecycle Overrides
  override func layoutSublayers() {
    for layer in [tipLayer] {
      layer.bounds = bounds
      layer.position = center
    }
    preparePaths()
  }
  
  //MARK:- Utility methods
  private func preparePaths() {
    tipLayer.path = tipPath
  }
}

let tip = RingTip()
tip.color = UIColor.hrPinkColor.CGColor
tip.ringWidth = 60.0
viewWithLayer(tip)



let ring = RingLayer()
ring.value = 0.6
ring.ringWidth = 60
ring.ringColors = (UIColor.hrPinkColor.CGColor, UIColor.hrPinkColor.darkerColor.CGColor)

viewWithLayer(ring)

