//
//  GalleryUIImage.swift
//  GalleryTest
//
//  Created by Sergey Rakov on 06.09.16.
//  Copyright © 2016 e-Legion. All rights reserved.
//

import UIKit

class GalleryUIImage {
    
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
}

//MARK: - GalleryImage

extension GalleryUIImage: GalleryImage {
    
    func setImageToZoomingView(zoomingView: ZoomingView) {
        zoomingView.image = image
    }
    
    func cancelSettingImageToZoomingView(zoomingView: ZoomingView) {
    }
}
