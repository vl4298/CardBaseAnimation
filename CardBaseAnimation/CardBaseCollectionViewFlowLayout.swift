//
//  CardBaseCollectionViewFlowLayout.swift
//  CardBaseAnimation
//
//  Created by Dinh Luu on 06/10/2016.
//  Copyright © 2016 Dinh Luu. All rights reserved.
//

import UIKit

func >(lhs: CGPoint, rhs: CGPoint) -> Bool {
  return lhs.x > rhs.x
}

class CardBaseCollectionLayoutAttribute: UICollectionViewLayoutAttributes {
  var topConstant: CGFloat = -40
  var alphaFactor: CGFloat = 0.0
  var scaleFactor: CGFloat = 1.5
  
  override func copyWithZone(zone: NSZone) -> AnyObject {
    if let attribute = super.copyWithZone(zone) as? CardBaseCollectionLayoutAttribute {
      attribute.topConstant = self.topConstant
      attribute.alphaFactor = alphaFactor
      attribute.scaleFactor = scaleFactor
      return attribute
    }
    
    return super.copyWithZone(zone)
  }
  
  override func isEqual(object: AnyObject?) -> Bool {
    if let attribute = object as? CardBaseCollectionLayoutAttribute {
      if attribute.topConstant == self.topConstant && attribute.alphaFactor == alphaFactor && attribute.scaleFactor == scaleFactor {
        return super.isEqual(object)
      }
    }
    
    return false
  }
}

class CardBaseCollectionViewFlowLayout: UICollectionViewFlowLayout {

  var collectionViewSize: CGSize {
    return collectionView!.bounds.size
  }
  
  var itemGap: CGFloat {
    return collectionViewSize.width / 14
  }
  
  var inset: CGFloat {
    return 10.0 + itemGap
  }
  
  var currentContentOffset: CGPoint = CGPointZero
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init() {
    super.init()
  }
  
  override class func layoutAttributesClass() -> AnyClass {
    return CardBaseCollectionLayoutAttribute.self
  }
  
  func setupLayout() {
    collectionView!.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    minimumLineSpacing = itemGap
    itemSize = CGSize(width: collectionViewSize.width - itemGap*2 - 20, height: collectionViewSize.height)
    currentContentOffset = CGPoint(x: 10.0, y: 0)
  }
  
  override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    return true
  }
  
  override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    var offsetAdjust: CGFloat = 10000
    
    let distanceXFromLastScroll = proposedContentOffset.x - currentContentOffset.x
    if fabs(distanceXFromLastScroll) < collectionViewSize.width/4 {
      return currentContentOffset
    }
    
    if proposedContentOffset > currentContentOffset {
      currentContentOffset.x = currentContentOffset.x + collectionViewSize.width/2
      //print("move forward: \(currentContentOffset)")
    } else {
      //print("move back: \(currentContentOffset)")
      currentContentOffset.x = currentContentOffset.x - collectionViewSize.width/2
    }
    
    let horizontalCenter = currentContentOffset.x + collectionView!.bounds.width / 2
    
    let proposedRect = CGRect(x: currentContentOffset.x,
                              y: 0.0,
                              width: collectionView!.bounds.width,
                              height: collectionView!.bounds.height)
    
    guard let attributesArray = super.layoutAttributesForElementsInRect(proposedRect) else { return proposedContentOffset }
    
    for attribute in attributesArray {
      if case UICollectionElementCategory.SupplementaryView = attribute.representedElementCategory { continue }
      
      let itemHorizontalCenter = attribute.center.x
//      if fabs(itemHorizontalCenter - horizontalCenter) < fabs(offsetAdjust) {
//        offsetAdjust = itemHorizontalCenter - horizontalCenter
//      }
      offsetAdjust = itemHorizontalCenter - horizontalCenter
    }
    
    return CGPoint(x: currentContentOffset.x + offsetAdjust, y: currentContentOffset.y + offsetAdjust)
  }
  
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    guard let attributesArray = super.layoutAttributesForElementsInRect(rect) else { return nil }
    
    guard let collectionView = self.collectionView else { return attributesArray }
    
    let visibleRect = CGRect(x: collectionView.contentOffset.x,
                             y: collectionView.contentOffset.y,
                             width: collectionView.bounds.width,
                             height: collectionView.bounds.height)
    
    for attribute in attributesArray {
      apply(layoutAttributes: attribute as! CardBaseCollectionLayoutAttribute, for: visibleRect)
    }
    
    return attributesArray
  }
  
  override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    guard let attribute = super.layoutAttributesForItemAtIndexPath(indexPath) else { return nil }
    
    let visibleRect = CGRect(x: collectionView!.contentOffset.x,
                             y: collectionView!.contentOffset.y,
                             width: collectionView!.bounds.width,
                             height: collectionView!.bounds.height)
    apply(layoutAttributes: attribute as! CardBaseCollectionLayoutAttribute, for: visibleRect)
    
    return attribute
  }
  
  func apply(layoutAttributes attributes: CardBaseCollectionLayoutAttribute, for visibleRect: CGRect) {
    let maxConstant = collectionViewSize.height/2 + 40.0
    let ACTIVE_DISTANCE = collectionView!.bounds.width/2 + 10.0
    // skip supplementary kind
    if case UICollectionElementCategory.SupplementaryView = attributes.representedElementCategory { return }
    
    let distanceFromVisibleRectToItem: CGFloat = visibleRect.midX - attributes.center.x
    if fabs(distanceFromVisibleRectToItem) < ACTIVE_DISTANCE {
      
      let normalizeDistance = fabs(distanceFromVisibleRectToItem) / ACTIVE_DISTANCE
      
      let factorScale = 1 - normalizeDistance
      attributes.topConstant = -40 + (factorScale * maxConstant)
      attributes.alphaFactor = factorScale
      attributes.scaleFactor = 1.5 - 0.5*factorScale
    } else {
      attributes.topConstant = -40
      attributes.alphaFactor = 0.0
    }
    
  }

}
