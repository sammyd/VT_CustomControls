import UIKit

@IBDesignable
class ThreeRingView : UIView {
  
  private let rings = [RingLayer(), RingLayer(), RingLayer()]
  
  @IBInspectable
  dynamic var colorInnerRing = UIColor(red:  33.0/255.0, green: 253.0/255.0, blue: 197.0/255.0, alpha: 1.0) {
    didSet {
      setColor(colorInnerRing, ofRing: rings[2])
    }
  }
  @IBInspectable
  var colorMiddleRing = UIColor(red: 158.0/255.0, green: 255.0/255.0, blue:   9.0/255.0, alpha: 1.0) {
    didSet {
      setColor(colorMiddleRing, ofRing: rings[1])
    }
  }
  @IBInspectable
  var colorOuterRing = UIColor(red: 251.0/255.0, green:  12.0/255.0, blue: 116.0/255.0, alpha: 1.0) {
    didSet {
      setColor(colorOuterRing, ofRing: rings[0])
    }
  }
  
  @IBInspectable
  var ringBackgroundColor = UIColor(white: 0.15, alpha: 1.0) {
    didSet {
      for ring in rings {
        ring.ringBackgroundColor = ringBackgroundColor.CGColor
      }
    }
  }
  
  @IBInspectable
  dynamic var valueInnerRing : CGFloat = 1.75 {
    didSet {
      rings[2].value = valueInnerRing
    }
  }
  
  @IBInspectable
  var valueMiddleRing : CGFloat = 1.08 {
    didSet {
      rings[1].value = valueMiddleRing
    }
  }
  
  @IBInspectable
  var valueOuterRing : CGFloat = 1.35 {
    didSet {
      rings[0].value = valueOuterRing
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
  
  private func sharedInitialization() {
    for ring in rings {
      layer.addSublayer(ring)
      ring.ringBackgroundColor = ringBackgroundColor.CGColor
      ring.ringWidth = ringWidth
    }
    
    // Set the default values
    for (color, ring) in zip([colorOuterRing, colorMiddleRing, colorInnerRing], rings) {
      setColor(color, ofRing: ring)
    }
    
    for (value, ring) in zip([valueOuterRing, valueMiddleRing, valueInnerRing], rings) {
      ring.value = value
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    backgroundColor = UIColor.blackColor()
    drawLayers()
  }
  
  override func prepareForInterfaceBuilder() {
    for ring in rings {
      ring.animationEnabled = false
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
  
  private func setColor(color: UIColor, ofRing ring: RingLayer) {
    ring.ringColors = (color.CGColor, color.darkerColor.CGColor)
  }

}
