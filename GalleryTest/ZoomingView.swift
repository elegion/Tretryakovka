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

    private(set) var scrollView: UIScrollView!
    private(set) var imageView: UIImageView!
    private var toggleZoomRecognizer: UITapGestureRecognizer!

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
        scrollView.addSubview(imageView)
        
        toggleZoomRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleScale))
        toggleZoomRecognizer.numberOfTapsRequired = 2
        
        minimumZoomScale = kDefaultMinimumZoomScale
        maximumZoomScale = kDefaultMaximumZoomScale
    }
}

//MARK: Life Cycle

extension ZoomingView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resetScale()
    }
}

//MARK: - Public

extension ZoomingView {
    
    @IBInspectable var image: UIImage? {
        get { return imageView.image }
        set { imageView.image = newValue }
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
}

//MARK: Private

extension ZoomingView {
    
    func toggleScale() {
        let targetScale = scrollView.zoomScale == 1 ? maximumZoomScale : 1
        scrollView.setZoomScale(targetScale, animated: true)
    }
    
    func resetScale() {
        scrollView.zoomScale = 1
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.contentSize = scrollView.frame.size
        scrollView.contentOffset = CGPointZero
        imageView.frame = scrollView.bounds
    }
}

//MARK: Scroll View

extension ZoomingView: UIScrollViewDelegate {
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        if scrollView.zoomScale > 1 {
            let scrollViewContentSize = CGSizeMake(max(imageViewSize.width, scrollViewSize.width),
                                                   max(imageViewSize.height, scrollViewSize.height))
            scrollView.contentSize = scrollViewContentSize
            imageView.center = CGPointMake(scrollViewContentSize.width/2,
                                           scrollViewContentSize.height/2)
        } else {
            scrollView.contentSize = scrollViewSize
            imageView.center = CGPointMake(scrollView.bounds.width / 2, scrollView.bounds.height/2)
        }
    }
}
