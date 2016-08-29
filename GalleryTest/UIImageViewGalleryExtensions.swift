//
//  UIImageViewGalleryExtensions.swift
//  GalleryTest
//
//  Created by Sergey Rakov on 29.08.16.
//  Copyright © 2016 e-Legion. All rights reserved.
//

import UIKit

extension UIImageView {

    func currentImageSize() -> CGSize {
        guard let image = image else { return CGSizeZero }
        
        switch contentMode {
        case .ScaleToFill,
             .Redraw:
            return frame.size
        case .ScaleAspectFit:
            var imageSize = image.size
            let viewSize = frame.size
            
            let widthScale = viewSize.width / imageSize.width
            let heightScale = viewSize.height / imageSize.height
            
            let scale = min(widthScale, heightScale)
            imageSize.width *= scale
            imageSize.height *= scale
            
            return imageSize
        case .ScaleAspectFill:
            var imageSize = image.size
            let viewSize = frame.size
            
            let widthScale = viewSize.width / imageSize.width
            let heightScale = viewSize.height / imageSize.height
            
            let scale = max(widthScale, heightScale)
            imageSize.width *= scale
            imageSize.height *= scale
            
            return imageSize
        default:
            return image.size
        }
    }
}
