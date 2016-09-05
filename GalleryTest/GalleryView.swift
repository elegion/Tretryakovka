//
//  GalleryView.swift
//  GalleryTest
//
//  Created by Sergey Rakov on 06.09.16.
//  Copyright © 2016 e-Legion. All rights reserved.
//

import UIKit

private let GalleryCellIdentifier = "GalleryCell"

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
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.sectionInset = UIEdgeInsetsZero
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        collectionView.pagingEnabled = true
        collectionView.registerClass(GalleryCell.self, forCellWithReuseIdentifier: GalleryCellIdentifier)
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
    }
}

//MARK: - Collection

extension GalleryView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(GalleryCellIdentifier, forIndexPath: indexPath) as! GalleryCell
        cell.image = images[indexPath.row]
        cell.minimumZoomScale = minimumZoomScale
        cell.maximumZoomScale = maximumZoomScale
        cell.toggleZoomOnDoubleTap = toggleZoomOnDoubleTap
        return cell
    }
}
