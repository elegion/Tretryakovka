//
//  GalleryImage.swift
//  GalleryTest
//
//  Created by Sergey Rakov on 05.09.16.
//  Copyright © 2016 e-Legion. All rights reserved.
//

import UIKit

protocol GalleryImage {
    func setImageToZoomingView(zoomingView: ZoomingView)
    func cancelSettingImageToZoomingView(zoomingView: ZoomingView)
}
