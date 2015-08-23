//
//  ColorPicker.swift
//  SketchPad
//
//  Created by Sam Davies on 15/08/2015.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

@IBDesignable
class ColorPicker : UIControl {
  private var colorRing : ColorRing?
  private var gestureRecognizer : AngleGestureRecognizer?
  private var transformAtStartOfGesture : CGAffineTransform?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    sharedInitialization()
  }
  
  required init?(coder aDecoder: NSCoder) {
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
    
    gestureRecognizer = AngleGestureRecognizer(target: self, action: "handleAngleGestureChange")
    addGestureRecognizer(gestureRecognizer!)
  }
}

extension ColorPicker {
  func handleAngleGestureChange() {
    switch gestureRecognizer!.state {
    case UIGestureRecognizerState.Began:
      transformAtStartOfGesture = colorRing?.transform
    case .Changed:
      colorRing?.transform = CGAffineTransformRotate(transformAtStartOfGesture!, gestureRecognizer!.angleDelta)
    default:
      transformAtStartOfGesture = .None
    }
    
    sendActionsForControlEvents(.ValueChanged)
  }
}

extension ColorPicker {
  @IBInspectable
  var ringWidth : CGFloat {
    set(newWidth) {
      colorRing?.ringWidth = newWidth
    }
    get {
      return colorRing?.ringWidth ?? 0
    }
  }
  
  @IBInspectable
  var selectedColor : UIColor {
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

