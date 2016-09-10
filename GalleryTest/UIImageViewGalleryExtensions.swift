//
//  UIImageViewGalleryExtensions.swift
//  GalleryTest
//
//  Created by Sergey Rakov on 29.08.16.
//  Copyright © 2016 e-Legion. All rights reserved.
//

import UIKit

extension UIImageView {

    func imageSizeForScale(scale: CGFloat) -> CGSize {
        guard let image = image else { return CGSizeZero }
        
        let currentViewSize = bounds.size
        let scaledViewSize = CGSizeMake(currentViewSize.width * scale, currentViewSize.height * scale)
        
        switch contentMode {
        case .ScaleToFill,
             .Redraw:
            return frame.size
        case .ScaleAspectFit:
            var imageSize = image.size
            
            let widthScale = scaledViewSize.width / imageSize.width
            let heightScale = scaledViewSize.height / imageSize.height
            
            let scale = min(widthScale, heightScale)
            imageSize.width *= scale
            imageSize.height *= scale
            
            return imageSize
        case .ScaleAspectFill:
            var imageSize = image.size
            
            let widthScale = scaledViewSize.width / imageSize.width
            let heightScale = scaledViewSize.height / imageSize.height
            
            let scale = max(widthScale, heightScale)
            imageSize.width *= scale
            imageSize.height *= scale
            
            return imageSize
        default:
            return image.size
        }
    }
}
