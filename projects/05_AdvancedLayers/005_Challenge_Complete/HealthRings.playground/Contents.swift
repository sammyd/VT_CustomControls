import UIKit
import XCPlayground


class ThreeRingView : UIView {
  
  private enum RingIndex : Int {
    case Inner  = 0
    case Middle = 1
    case Outer  = 2
  }
  
  private let rings : [RingIndex : RingLayer] = [.Inner : RingLayer(), .Middle : RingLayer(), .Outer : RingLayer()]
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    sharedInitialization()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    sharedInitialization()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    drawLayers()
  }
  
  
  private func sharedInitialization() {
    backgroundColor = UIColor.blackColor()
    for (_, ring) in rings {
      layer.addSublayer(ring)
      ring.backgroundColor = UIColor.clearColor().CGColor
      ring.ringBackgroundColor = ringBackgroundColor.CGColor
      ring.ringWidth = ringWidth
    }
    
    // Set the default values
    for (color, (index, ring)) in zip([UIColor.hrPinkColor, UIColor.hrGreenColor, UIColor.hrBlueColor], rings) {
      setColorForRing(index, color: color)
      ring.value = 0.0
    }
  }
  
  private func drawLayers() {
    let size = min(bounds.width, bounds.height)
    for (index, ring) in rings {
      // Sort sizes
      let curSize = size - CGFloat(index.rawValue) * ( ringWidth + ringPadding ) * 2.0
      ring.bounds = CGRect(x: 0, y: 0, width: curSize, height: curSize)
      ring.position = layer.position
    }
  }
  
  //: API Properties
  var ringWidth : CGFloat = 20.0 {
    didSet {
      drawLayers()
      for (_, ring) in rings {
        ring.ringWidth = ringWidth
      }
    }
  }
  var ringPadding : CGFloat = 1.0 {
    didSet {
      drawLayers()
    }
  }
  var ringBackgroundColor : UIColor = UIColor.darkGrayColor() {
    didSet {
      for (_, ring) in rings {
        ring.ringBackgroundColor = ringBackgroundColor.CGColor
      }
    }
  }
}

//: Values
extension ThreeRingView {
  var innerRingValue : CGFloat {
    get {
      return rings[.Inner]?.value ?? 0
    }
    set(newValue) {
      rings[.Inner]?.value = newValue
    }
  }
  var middleRingValue : CGFloat {
    get {
      return rings[.Middle]?.value ?? 0
    }
    set(newValue) {
      rings[.Middle]?.value = newValue
    }
  }
  var outerRingValue : CGFloat {
    get {
      return rings[.Outer]?.value ?? 0
    }
    set(newValue) {
      rings[.Outer]?.value = newValue
    }
  }
}

//: Colors
extension ThreeRingView {
  var innerRingColor : UIColor {
    get {
      return colorForRing(.Inner)
    }
    set(newColor) {
      setColorForRing(.Inner, color: newColor)
    }
  }
  var middleRingColor : UIColor {
    get {
      return UIColor.clearColor()
    }
    set(newColor) {
      setColorForRing(.Middle, color: newColor)
    }
  }
  var outerRingColor : UIColor {
    get {
      return UIColor.clearColor()
    }
    set(newColor) {
      setColorForRing(.Outer, color: newColor)
    }
  }
  
  private func colorForRing(index: RingIndex) -> UIColor {
    return UIColor(CGColor: rings[index]!.ringColors.0)
  }
  
  private func setColorForRing(index: RingIndex, color: UIColor) {
    rings[index]?.ringColors = (color.CGColor, color.darkerColor.CGColor)
  }
}

let threeRings = ThreeRingView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
threeRings.ringWidth = 30.0
threeRings.ringPadding = 2
threeRings.innerRingValue = 0.4
threeRings.middleRingValue = 0.9
threeRings.outerRingValue = 1.4





