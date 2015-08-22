import UIKit
import XCPlayground


class ThreeRingView : UIView {
  
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
  }
  
  private func drawLayers() {
    
  }
  
  //: API Properties
  var ringWidth : CGFloat = 0.0
  var ringPadding : CGFloat = 0.0
  var ringBackgroundColor : UIColor = UIColor.darkGrayColor()
}

//: Values
extension ThreeRingView {
  var innerRingValue : CGFloat {
    get {
      return 0
    }
    set(newValue) {
      
    }
  }
  var middleRingValue : CGFloat {
    get {
      return 0
    }
    set(newValue) {
      
    }
  }
  var outerRingValue : CGFloat {
    get {
      return 0
    }
    set(newValue) {
      
    }
  }
}

//: Colors
extension ThreeRingView {
  var innerRingColor : UIColor {
    get {
      return UIColor.clearColor()
    }
    set(newColor) {
      
    }
  }
  var middleRingColor : UIColor {
    get {
      return UIColor.clearColor()
    }
    set(newColor) {
      
    }
  }
  var outerRingColor : UIColor {
    get {
      return UIColor.clearColor()
    }
    set(newColor) {
      
    }
  }
}

let threeRings = ThreeRingView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
threeRings

