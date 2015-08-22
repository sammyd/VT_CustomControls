import UIKit
import XCPlayground


let ring = RingLayer()
ring.value = 1.6
ring.ringWidth = 40
ring.ringColors = (UIColor.hrPinkColor.CGColor, UIColor.hrPinkColor.darkerColor.CGColor)

viewWithLayer(ring)

