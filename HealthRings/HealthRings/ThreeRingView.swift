import UIKit

@IBDesignable
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
      ring.value = proportion
    }
  }
}
