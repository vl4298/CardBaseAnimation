//
//  CardBaseCollectionViewCell.swift
//  CardBaseAnimation
//
//  Created by Dinh Luu on 06/10/2016.
//  Copyright © 2016 Dinh Luu. All rights reserved.
//

import UIKit

extension Int {
  var degreesToRadians: Double { return Double(self) * M_PI / 180 }
  var radiansToDegrees: Double { return Double(self) * 180 / M_PI }
}

protocol DoubleConvertible {
  init(_ double: Double)
  var double: Double { get }
}
extension Double : DoubleConvertible { var double: Double { return self         } }
extension Float  : DoubleConvertible { var double: Double { return Double(self) } }
extension CGFloat: DoubleConvertible { var double: Double { return Double(self) } }

class CardBaseCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var colorView: UIView!
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var colorViewTopConstraint: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    let angle: Double = (-10).degreesToRadians
    colorView.layer.transform = CATransform3DMakeRotation(CGFloat(angle), 0, 0, 1)
    label.alpha = 0.0
//    label.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.5)
  }
  
  override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
    guard let attribute = layoutAttributes as? CardBaseCollectionLayoutAttribute else { return }
    
    colorViewTopConstraint.constant = attribute.topConstant
    label.alpha = attribute.alphaFactor
//    print(attribute.scaleFactor)
//    label.layer.transform = CATransform3DMakeScale(1.0, 1.0, attribute.scaleFactor)
  }
}
