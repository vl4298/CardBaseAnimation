//
//  ViewController.swift
//  CardBaseAnimation
//
//  Created by Dinh Luu on 06/10/2016.
//  Copyright © 2016 Dinh Luu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let layoutManager = collectionView.collectionViewLayout as! CardBaseCollectionViewFlowLayout
    layoutManager.setupLayout()
  }

}

extension ViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    return collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath)
  }
}

extension ViewController: UICollectionViewDelegate, UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    let centerPointInView = self.view.center
    let centerPointInCollectionView = view.convertPoint(centerPointInView, toView: scrollView)
//    print(centerPointInCollectionView)
  }
}

