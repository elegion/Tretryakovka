//
//  GalleryUIImage.swift
//  GalleryTest
//
//  Created by Sergey Rakov on 06.09.16.
//  Copyright © 2016 e-Legion. All rights reserved.
//

import UIKit

class GalleryUIImage: GalleryImage {
    
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }

    func setImageToZoomingView(zoomingView: ZoomingView) {
        zoomingView.image = image
    }
}
