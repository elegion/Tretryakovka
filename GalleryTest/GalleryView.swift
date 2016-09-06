//
//  GalleryView.swift
//  GalleryTest
//
//  Created by Sergey Rakov on 06.09.16.
//  Copyright © 2016 e-Legion. All rights reserved.
//

import UIKit

private let kGalleryCellIdentifier = "GalleryCell"
private let kImageSpacing = 40 as CGFloat

class GalleryView: UIView {

    private var collectionView: UICollectionView!
    private var collectionViewLayout: UICollectionViewFlowLayout!
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .Horizontal
        collectionViewLayout.minimumLineSpacing = kImageSpacing
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.sectionInset = UIEdgeInsetsZero
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.registerClass(GalleryCell.self, forCellWithReuseIdentifier: kGalleryCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
    }

    //MARK: - Public
    
    var images: [GalleryImage] = [GalleryImage]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    @IBInspectable var minimumZoomScale: CGFloat = kDefaultMinimumZoomScale
    @IBInspectable var maximumZoomScale: CGFloat = kDefaultMaximumZoomScale
    @IBInspectable var toggleZoomOnDoubleTap: Bool = false
    
    //MARK: - Life Cycle

    override func layoutSubviews() {
        collectionViewLayout.itemSize = self.bounds.size
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.contentInset = UIEdgeInsetsZero
        collectionView.contentOffset = CGPointZero
    }
}

//MARK: - Collection

extension GalleryView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kGalleryCellIdentifier, forIndexPath: indexPath) as! GalleryCell
        cell.image = images[indexPath.row]
        cell.minimumZoomScale = minimumZoomScale
        cell.maximumZoomScale = maximumZoomScale
        cell.toggleZoomOnDoubleTap = toggleZoomOnDoubleTap
        return cell
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let targetOffset = targetContentOffset.memory.x
        guard 0 < targetOffset && targetOffset < scrollView.contentSize.width else { return }
        
        let imageWidth = bounds.width + kImageSpacing
        let currentIndex = floor(scrollView.contentOffset.x / imageWidth)
        let velocity = velocity.x

        var targetIndex: CGFloat
        if velocity > 0 {
            targetIndex = floor(currentIndex + 1)
        } else if velocity < 0 {
            targetIndex = floor(currentIndex)
        } else {
            targetIndex = floor(targetOffset / imageWidth + 0.5)
        }
        
        targetContentOffset.memory = CGPointMake(imageWidth * targetIndex, 0)
    }
}
