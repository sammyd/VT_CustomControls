import UIKit
import XCPlayground

public class RingLayer : CALayer {
  
  private let angleOffsetForZero = CGFloat(-M_PI_2)
  
  //:- Public API
  var value: CGFloat = 0.7
  var ringWidth: CGFloat = 40.0
  var ringColors: (CGColorRef, CGColorRef) = (UIColor.redColor().CGColor, UIColor.redColor().darkerColor.CGColor)
  var ringBackgroundColor: CGColorRef = UIColor.darkGrayColor().CGColor
  
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
  }
  
  public override func layoutSublayers() {
    super.layoutSublayers()
    guard let sublayers = sublayers else { return }
    if sublayers.first?.bounds != bounds {
      for layer in sublayers {
        layer.bounds = bounds
        layer.position = center
      }
    }
  }
}


let ring = RingLayer()

viewWithLayer(ring)

