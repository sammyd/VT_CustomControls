import UIKit

@IBDesignable
class ThreeRingView : UIView {
  
  private let rings = [RingLayer(), RingLayer(), RingLayer()]
  
  @IBInspectable
  var ringBackgroundColor = UIColor(white: 0.15, alpha: 1.0) {
    didSet {
      for ring in rings {
        ring.ringBackgroundColor = ringBackgroundColor.CGColor
      }
    }
  }
  
  @IBInspectable
  var ringWidth: CGFloat = 30.0 {
    didSet {
      drawLayers()
      for ring in rings {
        ring.ringWidth = ringWidth
      }
    }
  }
  
  @IBInspectable
  var ringPadding: CGFloat = 1.0 {
    didSet {
      drawLayers()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    sharedInitialization()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    sharedInitialization()
  }
}

// MARK:- Ring colors
extension ThreeRingView {
  @IBInspectable
  var colorInnerRing : UIColor {
    set(newColor) {
      setColor(newColor, ofRing: rings[2])
    }
    get {
      return UIColor(CGColor: rings[2].ringColors.0)
    }
  }
  
  @IBInspectable
  var colorMiddleRing : UIColor {
    set(newColor) {
      setColor(newColor, ofRing: rings[1])
    }
    get {
      return UIColor(CGColor: rings[1].ringColors.0)
    }
  }
  
  @IBInspectable
  var colorOuterRing : UIColor {
    set(newColor) {
      setColor(newColor, ofRing: rings[0])
    }
    get {
      return UIColor(CGColor: rings[0].ringColors.0)
    }
  }
  
  private func setColor(color: UIColor, ofRing ring: RingLayer) {
    ring.ringColors = (color.CGColor, color.darkerColor.CGColor)
  }
}


// MARK:- Ring values
extension ThreeRingView {
  @IBInspectable
  var valueInnerRing : CGFloat {
    set(newValue) {
      setValueInnerRing(newValue, animated: false)
    }
    get {
      return rings[2].value
    }
  }
  
  @IBInspectable
  var valueMiddleRing : CGFloat {
    set(newValue) {
      setValueMiddleRing(newValue, animated: false)
    }
    get {
      return rings[1].value
    }
  }
  
  @IBInspectable
  var valueOuterRing : CGFloat {
    set(newValue) {
      setValueOuterRing(newValue, animated: false)
    }
    get {
      return rings[0].value
    }
  }
}

// MARK:- Animation of ring values
extension ThreeRingView {
  func setValueInnerRing(value: CGFloat, animated: Bool = false) {
    rings[2].setValue(value, animated: animated)
  }
  
  func setValueMiddleRing(value: CGFloat, animated: Bool = false) {
    rings[1].setValue(value, animated: animated)
  }
  
  func setValueOuterRing(value: CGFloat, animated: Bool = false) {
    rings[0].setValue(value, animated: animated)
  }
}


// MARK:- UIView Overrides
extension ThreeRingView {
  override func layoutSubviews() {
    super.layoutSubviews()
    backgroundColor = UIColor.blackColor()
    drawLayers()
  }
}

// MARK:- Layout
extension ThreeRingView {
  private func sharedInitialization() {
    for ring in rings {
      layer.addSublayer(ring)
      ring.ringBackgroundColor = ringBackgroundColor.CGColor
      ring.ringWidth = ringWidth
    }
    
    // Set the default values
    for (color, ring) in zip([UIColor.hrPinkColor, UIColor.hrGreenColor, UIColor.hrBlueColor], rings) {
      setColor(color, ofRing: ring)
      ring.value = 0.0
    }
  }
  
  private func drawLayers() {
    let size = min(bounds.width, bounds.height)
    for ringIdx in 0 ..< rings.count {
      // Sort sizes
      let ring = rings[ringIdx]
      let curSize = size - CGFloat(ringIdx) * ( ringWidth + ringPadding ) * 2.0
      ring.bounds = CGRect(x: 0, y: 0, width: curSize, height: curSize)
      ring.position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
    }
  }
}

