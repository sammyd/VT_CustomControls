//: Playground - noun: a place where people can play

import UIKit

class ThreeRingView : UIView {
  
  let rings = [CAShapeLayer(), CAShapeLayer(), CAShapeLayer()]
  let colours = [UIColor.redColor(), UIColor.greenColor(), UIColor.blueColor()]
  let propFilled = [0.75, 1.3, 0.35]
  let ringWidth = 20.0
  let ringPadding = 4.0
  
  override func layoutSubviews() {
    super.layoutSubviews()
    backgroundColor = UIColor.blackColor()
    drawLayers()
  }
  
  private func drawLayers() {
    // Sort sizes
    let size = min(bounds.width, bounds.height)
    for ring in rings {
      ring.bounds = CGRect(x: 0, y: 0, width: size, height: size)
      ring.position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
      if ring.superlayer == nil {
        layer.addSublayer(ring)
      }
    }
    
    // Prepare paths
    for idx in 0..<rings.count {
      let ring = rings[idx]
      let curRadius = ring.bounds.width / 2.0 - CGFloat(ringWidth) / 2.0 - CGFloat(idx) * CGFloat(ringWidth + ringPadding)
      let start = CGFloat(-M_PI_2)
      let end = CGFloat(propFilled[idx] * 2 * M_PI - M_PI_2)
      let path = UIBezierPath(arcCenter: CGPoint(x: ring.bounds.width / 2.0, y: ring.bounds.height / 2.0),
        radius: curRadius, startAngle: start, endAngle: end, clockwise: true)
      ring.path = path.CGPath
    
      // Styling
      ring.fillColor = nil
      ring.lineCap = kCALineCapRound
      ring.lineWidth = CGFloat(ringWidth)
      ring.strokeColor = colours[idx].CGColor
    }
  }
}


let view = ThreeRingView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))






