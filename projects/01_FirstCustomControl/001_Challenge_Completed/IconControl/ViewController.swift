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

class ViewController: UIViewController {

  lazy var iconControl: IconControl = {
    return IconControl(frame: CGRect.zeroRect)
  }()
  
  @IBOutlet weak var otherIcon: IconControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    iconControl.text = "My Icon Control"
    iconControl.image = UIImage(named: "cocktail")
    iconControl.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
    iconControl.spacing = 50
    
    view.addSubview(iconControl)
    
    NSLayoutConstraint.activateConstraints(
      [
        iconControl.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
        iconControl.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor)
      ]
    )
    
  }
  
}

