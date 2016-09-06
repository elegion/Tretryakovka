//
//  ViewController.swift
//  GalleryTest
//
//  Created by Sergey Rakov on 24.08.16.
//  Copyright © 2016 e-Legion. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var galleryView: GalleryView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        automaticallyAdjustsScrollViewInsets = false
        
        galleryView.images = [
            GalleryUIImage(image: UIImage(named: "pic")!),
            GalleryUIImage(image: UIImage(named: "pic")!),
            GalleryUIImage(image: UIImage(named: "pic")!),
            GalleryUIImage(image: UIImage(named: "pic")!),
            GalleryUIImage(image: UIImage(named: "pic")!)
        ]
    }
    
    @IBAction func returnToGallery(segue: UIStoryboardSegue) {
        
    }
}
