//
//  ViewController.swift
//  HealthRings
//
//  Created by Sam Davies on 12/06/2015.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet var sliders: [UISlider]!
  @IBOutlet weak var healthRings: ThreeRingView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  @IBAction func updateRingValues(sender: AnyObject) {
    healthRings.setValueInnerRing(CGFloat(sliders[0].value ?? 0), animated: true)
    healthRings.setValueMiddleRing(CGFloat(sliders[1].value ?? 0), animated: true)
    healthRings.setValueOuterRing(CGFloat(sliders[2].value ?? 0), animated: true)
  }
}

