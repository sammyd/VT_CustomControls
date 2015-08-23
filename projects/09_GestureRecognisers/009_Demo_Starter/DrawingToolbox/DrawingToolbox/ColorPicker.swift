/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

@IBDesignable
public class ColorPicker : UIControl {
  private var colorRing : ColorRing?
  private var transformAtStartOfGesture : CGAffineTransform?
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    sharedInitialization()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    sharedInitialization()
  }
  
  private func sharedInitialization() {
    colorRing = ColorRing()
    guard let colorRing = colorRing else { return }
    colorRing.backgroundColor = UIColor.clearColor()
    addSubview(colorRing)
    
    colorRing.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activateConstraints(
      [
        colorRing.leftAnchor.constraintEqualToAnchor(leftAnchor),
        colorRing.rightAnchor.constraintEqualToAnchor(rightAnchor),
        colorRing.topAnchor.constraintEqualToAnchor(topAnchor),
        colorRing.bottomAnchor.constraintEqualToAnchor(bottomAnchor)
      ]
    )
    
    let selectedColorView = UIView()
    selectedColorView.translatesAutoresizingMaskIntoConstraints = false
    selectedColorView.backgroundColor = UIColor.clearColor()
    selectedColorView.layer.borderColor = UIColor(white: 0, alpha: 0.3).CGColor
    selectedColorView.layer.borderWidth = 3.0
    addSubview(selectedColorView)
    NSLayoutConstraint.activateConstraints(
      [
        selectedColorView.centerXAnchor.constraintEqualToAnchor(centerXAnchor),
        selectedColorView.topAnchor.constraintEqualToAnchor(topAnchor),
        selectedColorView.widthAnchor.constraintEqualToAnchor(widthAnchor, multiplier: 0.05),
        selectedColorView.heightAnchor.constraintEqualToAnchor(heightAnchor, multiplier: 0.3)
      ]
    )

  }
}

extension ColorPicker {
  @IBInspectable
  public var ringWidth : CGFloat {
    set(newWidth) {
      colorRing?.ringWidth = newWidth
    }
    get {
      return colorRing?.ringWidth ?? 0
    }
  }
  
  @IBInspectable
  public var selectedColor : UIColor {
    set(newColor) {
      colorRing?.transform = CGAffineTransformMakeRotation(newColor.angle)
    }
    
    get {
      if let angle = colorRing!.layer.valueForKeyPath("transform.rotation.z") as? CGFloat {
        return UIColor.colorForAngle(angle)
      } else {
        return UIColor.clearColor()
      }
    }
  }
}


private extension UIColor {
  private static func colorForAngle(angle: CGFloat) -> UIColor {
    var normalised = (CGFloat(3 / 2.0 * M_PI) - angle) / CGFloat(2 * M_PI)
    normalised = normalised - floor(normalised)
    if normalised < 0 {
      normalised += 1
    }
    return UIColor(hue: normalised, saturation: 1.0, brightness: 1.0, alpha: 1.0)
  }
  
  private var angle : CGFloat {
    var hue : CGFloat = 0.0
    getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
    return hue * CGFloat(2 * M_PI)
  }
}

