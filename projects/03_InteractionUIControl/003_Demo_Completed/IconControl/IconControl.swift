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
class IconControl : UIView {

  private lazy var imageView : UIImageView = {
    let iv = UIImageView()
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  private lazy var label : UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFontOfSize(30.0, weight: UIFontWeightLight)
    return label
  }()
  
  private var spacingConstraint : NSLayoutConstraint!
  
  @IBInspectable
  var spacing: CGFloat = 20.0 {
    didSet {
      spacingConstraint?.constant = spacing
    }
  }
  
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
  
}

// MARK: Utilities
extension IconControl {
  private func sharedInitialization() {
    translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)
    addSubview(imageView)
    
    label.textColor = tintColor
    
    spacingConstraint = label.leftAnchor.constraintEqualToAnchor(imageView.rightAnchor, constant: spacing)
    
    NSLayoutConstraint.activateConstraints(
      [
        imageView.leadingAnchor.constraintEqualToAnchor(layoutMarginsGuide.leadingAnchor),
        imageView.topAnchor.constraintEqualToAnchor(layoutMarginsGuide.topAnchor),
        imageView.bottomAnchor.constraintEqualToAnchor(layoutMarginsGuide.bottomAnchor),
        spacingConstraint,
        label.trailingAnchor.constraintEqualToAnchor(layoutMarginsGuide.trailingAnchor),
        imageView.centerYAnchor.constraintEqualToAnchor(label.centerYAnchor)
      ]
    )
    
    label.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
    imageView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
    setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
    
    layer.cornerRadius = 10
  }
}

extension IconControl {
  override func tintColorDidChange() {
    super.tintColorDidChange()
    label.textColor = tintColor
  }
}


