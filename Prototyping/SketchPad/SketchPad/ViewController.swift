//
//  ViewController.swift
//  SketchPad
//
//  Created by Sam Davies on 12/08/2015.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var colorPicker: ColorPicker!
  @IBOutlet weak var canvas: Canvas!
  
  
  @IBAction func handleColorPickerValueChanged(sender: AnyObject) {
    canvas.strokeColor = colorPicker.selectedColor
  }
  

}

