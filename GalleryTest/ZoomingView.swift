//
//  ZoomingView.swift
//  GalleryTest
//
//  Created by Sergey Rakov on 24.08.16.
//  Copyright © 2016 e-Legion. All rights reserved.
//

import UIKit

let kDefaultMinimumZoomScale = 0.5 as CGFloat
let kDefaultMaximumZoomScale = 4 as CGFloat

@IBDesignable
final class ZoomingView: UIView {

    private var scrollView: UIScrollView!
    private var imageView: UIImageView!
    private var toggleZoomRecognizer: UITapGestureRecognizer!

    //MARK - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        scrollView = UIScrollView(frame: bounds)
        scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        addSubview(scrollView)
        
        imageView = UIImageView(frame: bounds)
        imageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        imageView.contentMode = .ScaleAspectFit
        scrollView.addSubview(imageView)
        
        toggleZoomRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleScale))
        toggleZoomRecognizer.numberOfTapsRequired = 2
        
        minimumZoomScale = kDefaultMinimumZoomScale
        maximumZoomScale = kDefaultMaximumZoomScale
    }
    
    //MARK: - Public
    
    @IBInspectable var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
            resetScale()
        }
    }
    
    @IBInspectable var minimumZoomScale: CGFloat {
        get { return scrollView.minimumZoomScale }
        set {
            scrollView.minimumZoomScale = min(max(0.1, newValue), 1)
        }
    }
    
    @IBInspectable var maximumZoomScale: CGFloat {
        get { return scrollView.maximumZoomScale }
        set {
            scrollView.maximumZoomScale = min(max(1, newValue), 10)
        }
    }
    
    @IBInspectable var toggleZoomOnDoubleTap: Bool {
        get {
            guard let gestureRecognizers = gestureRecognizers else {
                return false
            }
            return gestureRecognizers.contains(toggleZoomRecognizer)
        }
        set {
            if (newValue) {
                addGestureRecognizer(toggleZoomRecognizer)
            } else {
                removeGestureRecognizer(toggleZoomRecognizer)
            }
        }
    }

    //MARK: Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resetScale()
    }

    //MARK: Private

    func toggleScale(sender: UITapGestureRecognizer) {
        guard image != nil else { return }

        if scrollView.zoomScale == 1 {
            scrollView.zoomToRect(targetZoomRectForTapLocation(sender.locationInView(imageView)),
                                  animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }
    
    func resetScale() {
        scrollView.zoomScale = 1
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.contentSize = scrollView.frame.size
        scrollView.contentOffset = CGPointZero
        imageView.frame = scrollView.bounds
    }
    
    func targetZoomRectForTapLocation(tapLocation: CGPoint) -> CGRect {
        let imageSize = imageView.imageSizeForScale(1)
        let imageViewSize = imageView.bounds.size
        
        let zoomCenter = CGPointMake(tapLocation.x / imageViewSize.width,
                                     tapLocation.y / imageViewSize.height)
        
        let originMiltiplierX = (zoomCenter.x - imageViewSize.width / imageSize.width / maximumZoomScale / 2) * imageSize.width / imageViewSize.width
        let originMiltiplierY = (zoomCenter.y - imageViewSize.height / imageSize.height / maximumZoomScale / 2) * imageSize.height / imageViewSize.height
        
        return CGRectMake(imageViewSize.width * originMiltiplierX,
                          imageViewSize.height * originMiltiplierY,
                          imageViewSize.width / maximumZoomScale,
                          imageViewSize.height / maximumZoomScale)
    }
}

//MARK: - Scroll View

extension ZoomingView: UIScrollViewDelegate {
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        let imageSize = imageView.imageSizeForScale(scrollView.zoomScale)
        let scrollViewSize = scrollView.bounds.size
        
        let scrollViewContentSize = CGSizeMake(max(imageSize.width, scrollViewSize.width),
                                               max(imageSize.height, scrollViewSize.height))
        scrollView.contentSize = scrollViewContentSize
        imageView.center = CGPointMake(scrollViewContentSize.width / 2,
                                       scrollViewContentSize.height / 2)
    }
}
