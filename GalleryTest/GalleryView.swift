//
//  GalleryView.swift
//  GalleryTest
//
//  Created by Sergey Rakov on 06.09.16.
//  Copyright © 2016 e-Legion. All rights reserved.
//

import UIKit

public let GalleryViewIndexDidChangeNotification = "com.gallery.GalleryViewIndexDidChangeNotification"

private let kGalleryCellIdentifier = "GalleryCell"
/// Spacing between images
private let kImageSpacing = 40 as CGFloat

class GalleryView: UIView {

    private var collectionView: UICollectionView!
    private var collectionViewLayout: UICollectionViewFlowLayout!

    private var imageWidth: CGFloat { return bounds.width + kImageSpacing }

    private(set) var currentIndex: Int = 0 {
        didSet {
            if currentIndex != oldValue {
                NSNotificationCenter.defaultCenter().postNotificationName(GalleryViewIndexDidChangeNotification, object: self)
            }
        }
    }
    
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
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
    
    func showImageAtIndex(index: Int, animated: Bool = false) {
        if collectionView.contentOffset.x != imageWidth * CGFloat(index) {
            collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0),
                                                   atScrollPosition: .CenteredHorizontally,
                                                   animated: animated)
        }
    }
    
    //MARK: - Life Cycle

    override func layoutSubviews() {

        /* 
         Resize collection and update layout.
         Collection is resized manually because of bug reporting logs appearing in case of autolayout.
         */
        if !CGSizeEqualToSize(collectionView.frame.size, bounds.size) {
            collectionViewLayout.itemSize = self.bounds.size
            collectionViewLayout.invalidateLayout()
            collectionView.frame = bounds
        }
        
        super.layoutSubviews()

        // remove automatically adjusted inset
        if !UIEdgeInsetsEqualToEdgeInsets(collectionView.contentInset, UIEdgeInsetsZero) {
            collectionView.contentInset = UIEdgeInsetsZero
        }

        // scroll to last shown image
        showImageAtIndex(currentIndex)
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
        
        let currentIndex = Int(scrollView.contentOffset.x / imageWidth)
        let velocity = velocity.x

        var targetIndex: Int
        if velocity > 0 {
            targetIndex = currentIndex + 1
        } else if velocity < 0 {
            targetIndex = currentIndex
        } else {
            targetIndex = Int(targetOffset / imageWidth + 0.5)
        }
        
        targetContentOffset.memory = CGPointMake(imageWidth * CGFloat(targetIndex), 0)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / imageWidth + 0.5)
    }
}
