//
//  IconControl.swift
//  IconControl
//
//  Created by Sam Davies on 11/08/2015.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

@IBDesignable
class IconControl : UIControl {
  
  private lazy var imageView : UIImageView = {
    let iv = UIImageView()
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  private var label : UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFontOfSize(30.0, weight: UIFontWeightLight)
    return label
  }()
  
  private var spacingConstraint : NSLayoutConstraint!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    sharedInitialization()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    sharedInitialization()
  }
  
  override func tintColorDidChange() {
    label.textColor = tintColor
  }
}


// MARK:- Public API
extension IconControl {
  @IBInspectable
  var image: UIImage? {
    get {
      return imageView.image
    }
    set(newImage) {
      imageView.image = newImage?.imageWithRenderingMode(.AlwaysTemplate)
    }
  }
  
  @IBInspectable
  var text: String? {
    get {
      return label.text
    }
    set(newText) {
      label.text = newText
    }
  }
  
  @IBInspectable
  var spacing: CGFloat {
    get {
      return spacingConstraint.constant
    }
    set(newSpacing) {
      spacingConstraint.constant = newSpacing
    }
  }
}


extension IconControl {
  private func sharedInitialization() {
    label.textColor = tintColor
    
    addSubview(label)
    addSubview(imageView)
    
    spacingConstraint = label.leftAnchor.constraintEqualToAnchor(imageView.rightAnchor, constant: 0)
    
    NSLayoutConstraint.activateConstraints(
      [
        imageView.leadingAnchor.constraintEqualToAnchor(layoutMarginsGuide.leadingAnchor),
        imageView.topAnchor.constraintEqualToAnchor(layoutMarginsGuide.topAnchor),
        imageView.bottomAnchor.constraintEqualToAnchor(layoutMarginsGuide.bottomAnchor),
        spacingConstraint,
        label.rightAnchor.constraintEqualToAnchor(layoutMarginsGuide.rightAnchor),
        imageView.centerYAnchor.constraintEqualToAnchor(label.centerYAnchor)
      ]
    )
    
    label.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
    imageView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
    setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
    
    layer.cornerRadius = 10
    
    addTapGestureRecognizer()
  }
}


extension IconControl {
  private func addTapGestureRecognizer() {
    let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
    addGestureRecognizer(tapGesture)
  }
  
  func handleTap(sender: UITapGestureRecognizer) {
    sendActionsForControlEvents(.TouchUpInside)
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    animateTintAdjustmentMode(.Dimmed)
  }
  
  override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    animateTintAdjustmentMode(.Normal)
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    animateTintAdjustmentMode(.Normal)
  }
  
  private func animateTintAdjustmentMode(mode: UIViewTintAdjustmentMode) {
    UIView.animateWithDuration(mode == .Normal ? 0.3 : 0.05) {
      self.tintAdjustmentMode = mode
    }
  }
}

