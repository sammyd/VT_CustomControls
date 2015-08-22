import UIKit
import XCPlayground

public class RingLayer : CALayer {
  
  private let angleOffsetForZero = CGFloat(-M_PI_2)
  
  //:- Public API
  var ringWidth: CGFloat = 20.0
  var value: CGFloat = 0.7
  var ringColors: (CGColorRef, CGColorRef) = (UIColor.redColor().CGColor, UIColor.blackColor().CGColor)
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
        layer.position = position
      }
    }
  }
}



viewWithLayer(RingLayer())

