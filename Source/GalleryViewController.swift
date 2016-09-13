//
//  GalleryViewController.swift
//  Tretyakovka
//
//  Created by Sergey Rakov on 08.09.16.
//  Copyright © 2016 e-Legion. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {

    private var navigationBar: UINavigationBar!
    private var galleryView: GalleryView!
    private var navBarHideRecognizer: UITapGestureRecognizer!
    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        automaticallyAdjustsScrollViewInsets = false
        
        view.backgroundColor = UIColor.whiteColor()
        
        navigationBar = UINavigationBar(frame: CGRectMake(0, 0, view.bounds.width, 64))
        navigationBar.autoresizingMask = [.FlexibleWidth, .FlexibleBottomMargin]
        navigationBar.delegate = self
        view.addSubview(navigationBar)
        
        galleryView = GalleryView(frame: view.bounds)
        galleryView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        galleryView.toggleZoomOnDoubleTap = true
        if images.count > 0 {
            galleryView.images = images
        }
        view.insertSubview(galleryView, belowSubview: navigationBar)
        
        navBarHideRecognizer = UITapGestureRecognizer(target: self, action: #selector(onViewTapped))
        navBarHideRecognizer.delegate = self
        view.addGestureRecognizer(navBarHideRecognizer)
    }
    
    deinit {
        galleryIndexObservationEnabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarCustomized(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        galleryIndexObservationEnabled = true
        onGalleryIndexChanged(nil)
        resetNavigationBar()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        galleryIndexObservationEnabled = false
        setNavigationBarCustomized(false)
    }
    
    //MARK: - Public
    
    var images: [GalleryImage] = [GalleryImage]() {
        didSet {
            galleryView?.images = images
        }
    }
    
    var backItem: UIBarButtonItem?
    var backButtonAction: ((Void) -> (Void))?
    
    //MARK: - UI Events
    
    func onViewTapped() {
        self.navigationBarHidden = !navigationBarHidden
    }
    
    private func onBackPressed() {
        if let backButtonAction = backButtonAction {
            backButtonAction()
        } else {
            if navigationController != nil {
                navigationController?.popViewControllerAnimated(true)
            } else {
                dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    //MARK: - Observation
    
    private var galleryIndexObservationEnabled: Bool = false {
        didSet {
            guard galleryIndexObservationEnabled != oldValue else { return }
            if galleryIndexObservationEnabled {
                NSNotificationCenter.defaultCenter().addObserver(self,
                                                                 selector: #selector(onGalleryIndexChanged),
                                                                 name: GalleryViewIndexDidChangeNotification,
                                                                 object: galleryView)
            } else {
                NSNotificationCenter.defaultCenter().removeObserver(self,
                                                                    name: GalleryViewIndexDidChangeNotification,
                                                                    object: galleryView)
            }
        }
    }
    
    func onGalleryIndexChanged(notification: NSNotification?) {
        guard let toggleZoomRecognizer = galleryView.activeToggleZoomGestureRecognizer else { return }
        navBarHideRecognizer.requireGestureRecognizerToFail(toggleZoomRecognizer)
    }
    
    //MARK: - Private
    
    private var navigationBarHidden: Bool {
        get {
            return navigationBar.alpha < 1
        }
        set {
            UIView.animateWithDuration(0.25) {
                self.navigationBar.alpha = newValue ? 0 : 1
                self.view.backgroundColor = newValue ? UIColor.blackColor() : UIColor.whiteColor()
            }
        }
    }
    
    private var originalNavigationBarHidden: Bool = false
    
    func setNavigationBarCustomized(customized: Bool) {

        let backNavigationItem = UINavigationItem()
        var backItem = self.backItem
        if backItem == nil {
            backItem = UIBarButtonItem(barButtonSystemItem: .Done, target: nil, action: nil)
        }
        backNavigationItem.backBarButtonItem = backItem
        navigationBar.setItems([backNavigationItem, navigationItem], animated: false)

        guard let navigationController = navigationController else { return }
        
        if customized {
            originalNavigationBarHidden = navigationController.navigationBarHidden
            navigationController.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController.setNavigationBarHidden(originalNavigationBarHidden, animated: true)
        }
    }
    
    /// Fix disappearing title after viewDidAppear
    private func resetNavigationBar() {
        let delegate = navigationBar.delegate
        navigationBar.delegate = nil // disable pop processing

        navigationBar.popNavigationItemAnimated(false)
        navigationBar.pushNavigationItem(navigationItem, animated: false)

        navigationBar.delegate = delegate
    }
}

extension GalleryViewController: UINavigationBarDelegate {
    
    func navigationBar(navigationBar: UINavigationBar, shouldPopItem item: UINavigationItem) -> Bool {
        navigationBar.items = [navigationItem] // weird crash on pop on iOS 8 otherwise
        onBackPressed()
        return false // incorrect nav bar state on deallocation otherwise
    }
}

extension GalleryViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        guard let touchView = touch.view else { return true }
        return !touchView.isDescendantOfView(navigationBar)
    }
}
