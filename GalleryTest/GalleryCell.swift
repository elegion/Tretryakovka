//
//  GalleryCell.swift
//  GalleryTest
//
//  Created by Sergey Rakov on 06.09.16.
//  Copyright © 2016 e-Legion. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    
    private var zoomingView: ZoomingView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        zoomingView = ZoomingView(frame: bounds)
        zoomingView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(zoomingView)
    }

    //MARK: - Public
    
    var image: GalleryImage? {
        didSet {
            image?.setImageToZoomingView(zoomingView)
        }
    }

    var minimumZoomScale: CGFloat {
        get { return zoomingView.minimumZoomScale }
        set { zoomingView.minimumZoomScale = newValue }
    }
    
    @IBInspectable var maximumZoomScale: CGFloat {
        get { return zoomingView.maximumZoomScale }
        set { zoomingView.maximumZoomScale = newValue }
    }
    
    @IBInspectable var toggleZoomOnDoubleTap: Bool {
        get { return zoomingView.toggleZoomOnDoubleTap }
        set { zoomingView.toggleZoomOnDoubleTap = newValue }
    }
}
