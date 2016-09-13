//
//  GalleryURLImage.swift
//  GalleryTest
//
//  Created by Sergey Rakov on 12.09.16.
//  Copyright © 2016 e-Legion. All rights reserved.
//

import UIKit
import AlamofireImage

class GalleryURLImage {
    
    let URL: NSURL
    let placeholderImage: UIImage?
    let placeholderView: UIView?
    
    init(URL: NSURL, placeholderImage: UIImage? = nil, placeholderView: UIView? = nil) {
        self.URL = URL
        self.placeholderImage = placeholderImage
        self.placeholderView = placeholderView
    }
    
    convenience init(URLString: String, placeholderImage: UIImage? = nil, placeholderView: UIView? = nil) {
        let URL = NSURL(string: URLString)
        assert(URL != nil)
        self.init(URL: URL!, placeholderImage: placeholderImage, placeholderView: placeholderView)
    }
    
    //MARK: - Private
    
    private func createDefaultPlaceholderView() -> UIView {
        let viewDefaultFrame = CGRectMake(0, 0, 44, 44)
        let view = UIView(frame: viewDefaultFrame)
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        activityIndicator.color = UIColor.grayColor()
        activityIndicator.center = CGPointMake(viewDefaultFrame.width / 2, viewDefaultFrame.height / 2)
        activityIndicator.autoresizingMask = [.FlexibleLeftMargin, .FlexibleTopMargin, .FlexibleRightMargin, .FlexibleBottomMargin]
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        return view
    }
}

//MARK: - GalleryImage

extension GalleryURLImage: GalleryImage {
    
    func setImageToZoomingView(zoomingView: ZoomingView) {
        
        var placeholderView = self.placeholderView
        if placeholderView == nil && placeholderImage == nil {
            placeholderView = createDefaultPlaceholderView()
        }
        if placeholderView != nil {
            placeholderView?.frame = zoomingView.bounds
            placeholderView?.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            zoomingView.addSubview(placeholderView!)
        }
        
        zoomingView.image = nil
        zoomingView.imageView.af_setImageWithURL(URL, placeholderImage: placeholderImage) { response in
            placeholderView?.removeFromSuperview()
        }
    }
    
    func cancelSettingImageToZoomingView(zoomingView: ZoomingView) {
        zoomingView.imageView.af_cancelImageRequest()
    }
}
