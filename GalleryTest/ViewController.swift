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

    @IBAction func onItem3Pressed(sender: AnyObject) {

        let galleryController = GalleryViewController()
        galleryController.images = [
            GalleryUIImage(image: UIImage(named: "pic")!),
            GalleryUIImage(image: UIImage(named: "pic")!),
            GalleryUIImage(image: UIImage(named: "pic")!),
            GalleryUIImage(image: UIImage(named: "pic")!),
            GalleryUIImage(image: UIImage(named: "pic")!)
        ]

        navigationController?.pushViewController(galleryController, animated: true)

//        galleryController.backButtonAction = {
//            self.navigationController?.popViewControllerAnimated(true)
//        }
        
//        galleryController.backButtonAction = {
//            self.dismissViewControllerAnimated(true, completion: nil)
//        }
    }
    
    @IBAction func returnToGallery(segue: UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gallery" {
            let gallery = segue.destinationViewController as! GalleryViewController
            gallery.images = [
                GalleryUIImage(image: UIImage(named: "pic")!),
                GalleryUIImage(image: UIImage(named: "pic")!),
                GalleryUIImage(image: UIImage(named: "pic")!),
                GalleryUIImage(image: UIImage(named: "pic")!),
                GalleryUIImage(image: UIImage(named: "pic")!)
            ]
        }
    }
}
