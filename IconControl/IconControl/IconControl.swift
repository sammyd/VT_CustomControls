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
}


// MARK:- Public API
extension IconControl {
  @IBInspectable
  var image: UIImage? {
    get {
      return imageView.image
    }
    set(newImage) {
      imageView.image = newImage
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
}


extension IconControl {
  private func sharedInitialization() {
    stackView = UIStackView(arrangedSubviews: [imageView, label])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .Horizontal
    stackView.alignment = .Center
    addSubview(stackView)
    
    NSLayoutConstraint.activateConstraints(
      [
        stackView.leadingAnchor.constraintEqualToAnchor(leadingAnchor),
        stackView.trailingAnchor.constraintEqualToAnchor(trailingAnchor),
        stackView.topAnchor.constraintEqualToAnchor(topAnchor),
        stackView.bottomAnchor.constraintEqualToAnchor(bottomAnchor)
      ]
    )
  }
}

