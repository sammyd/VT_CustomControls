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
  
  private var stackView : UIStackView!

  
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
      return stackView.spacing
    }
    set(newSpacing) {
      stackView.spacing = newSpacing
    }
  }
}


extension IconControl {
  private func sharedInitialization() {
    label.textColor = tintColor
    stackView = UIStackView(arrangedSubviews: [imageView, label])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .Horizontal
    stackView.alignment = .Center
    addSubview(stackView)
    
    
    NSLayoutConstraint.activateConstraints(
      [
        stackView.leadingAnchor.constraintEqualToAnchor(layoutMarginsGuide.leadingAnchor),
        stackView.trailingAnchor.constraintEqualToAnchor(layoutMarginsGuide.trailingAnchor),
        stackView.topAnchor.constraintEqualToAnchor(layoutMarginsGuide.topAnchor),
        stackView.bottomAnchor.constraintEqualToAnchor(layoutMarginsGuide.bottomAnchor)
      ]
    )
    
    layer.cornerRadius = 10
  }
}

