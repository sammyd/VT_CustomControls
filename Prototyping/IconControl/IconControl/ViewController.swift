//
//  ViewController.swift
//  IconControl
//
//  Created by Sam Davies on 11/08/2015.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var iconControl: IconControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    iconControl.addTarget(self, action: "handleIconTap:", forControlEvents: .TouchUpInside)
  }
  
  func handleIconTap(sender: AnyObject) {
    print("Icon Tapped!")
  }
  
  @IBAction func handleAnotherIconTap(sender: AnyObject) {
    guard let sender = sender as? IconControl else { return }
    
    print("\(sender.text) tapped")
  }
  
  
}

