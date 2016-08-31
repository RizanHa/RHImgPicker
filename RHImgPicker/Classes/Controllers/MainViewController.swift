// The MIT License (MIT)
//
// Copyright (c) 2016 Rizan Hamza
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
//  MainViewController.swift
//  Pods
//
//  Created by rizan on 26/08/2016.
//
//


import UIKit
import Photos


private let SIZEOFBUTTONS_HEIGHT : CGFloat = 50
private let SIZEOFALBUMVIEW_HEIGHT : CGFloat = 400

class MainViewController: UIViewController, AlbumTableViewDelegate, PhotosCollectionViewDelegate {

  
    
    var doneBarButton: UIButton?
    var clearBarButton: UIButton?
    var albumButton : UIButton?
    
    
    var settings: RHImgPickerSettings = RHSettings.sharedInstance
    
    private var delegateRHImgPicker : RHImgPickerDelegate?
    
    
    let expandAnimator = RHAnimator()
    let shrinkAnimator = RHAnimator()
    
    private var defaultSelections: PHFetchResult?
    private var fetchResults : [PHFetchResult]
    
    
    private let albumTableView : AlbumTableView = AlbumTableView()
    
    private let photosCollectionViewOverLayer : UIView = UIView()
    private let photosCollectionView : PhotosCollectionView = PhotosCollectionView()
    
    private let proxyViewForStatusBar : UIView = UIView()
    
    private lazy var previewViewContoller: PreviewViewController? = {
        return PreviewViewController(nibName: nil, bundle: nil)
    }()
    
    
     //MARK: -
    
    
    
    
    let TAG = "PhotosViewController"
    func log(message : String) {
        print(TAG + " : " + message)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup(self.view.frame)
        
        setupLongPressOnPhotoCollection()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    
    
    //MARK: - init Methods
    
    
    required init(fetchResults: [PHFetchResult],
             defaultSelections: PHFetchResult? = nil,
            settings aSettings: RHImgPickerSettings,
                     delegate : RHImgPickerDelegate?) {
        
        
        self.fetchResults = fetchResults
        self.delegateRHImgPicker = delegate
        self.defaultSelections = defaultSelections
        self.settings = aSettings
        
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    /*
    deinit {
        
    } */
    
    
    
    
    /*
     * setup MainViewController
     */
    private func setup(frame : CGRect) {
        
        
        // hid navigation bar
        self.navigationController?.navigationBarHidden = true
        self.view.backgroundColor = self.settings.backgroundColor
        
        
        // Setup views
        
        
        
        let statusBarHeight : CGFloat = 0       ///UIApplication.sharedApplication().statusBarFrame.size.height
        
   
        
        
        photosCollectionView.photosCollectionViewDelegate = self
        photosCollectionView.setup(CGRectMake(0, statusBarHeight, frame.size.width, frame.size.height - statusBarHeight - SIZEOFBUTTONS_HEIGHT))      ///(photosView.bounds)
        photosCollectionView.clipsToBounds = false
        photosCollectionView.scrollsToTop = true
        photosCollectionView.backgroundColor =  self.settings.backgroundColor
        self.view.addSubview(photosCollectionView)
        
        
        photosCollectionViewOverLayer.frame = photosCollectionView.bounds
        photosCollectionViewOverLayer.clipsToBounds = false
        photosCollectionViewOverLayer.backgroundColor = UIColor.clearColor()
        photosCollectionViewOverLayer.userInteractionEnabled = false
        self.view.addSubview(photosCollectionViewOverLayer)
        
        
        
        
        
 
        
        let albumFrame = CGRectMake(0, frame.size.height, frame.size.width, SIZEOFALBUMVIEW_HEIGHT - SIZEOFBUTTONS_HEIGHT)
        
        albumTableView.albumTableViewDelegate = self
        albumTableView.backgroundColor = UIColor.clearColor()
        albumTableView.setup(albumFrame, albumsDataSource: AlbumTableViewDataSource(fetchResults: self.fetchResults, settings: self.settings))
        albumTableView.scrollsToTop = false
        self.view.addSubview(albumTableView)
        
        

        
        
        
        
        
        // proxy view for status bar
        proxyViewForStatusBar.frame = CGRectMake(0, 0,self.view.frame.size.width, UIApplication.sharedApplication().statusBarFrame.size.height)
        proxyViewForStatusBar.backgroundColor = self.settings.backgroundColor
        self.view.addSubview(proxyViewForStatusBar)
        
 
        
        // Set navigation controller delegate
        navigationController?.delegate = self
      
        
        
        

        
        if self.settings.useToolBarButtons {
            setupToolBarButtons()
        }
        else {
            // Set Buttons
            setupButtons()
        }

        
        
        
        
        // init photos collection for first album
        if let album = self.albumTableView.albumsDataSource!.fetchResults.first?.firstObject as? PHAssetCollection {
            initializePhotosDataSource(album, selections: defaultSelections)
            self.photosCollectionView.synchronizeCollectionView()
        }

        
        
        
        
    }
    
    
    let buttonsView : UIView = UIView()
    let selectionCounterView : RHSelectionCounterView = RHSelectionCounterView()
    
    
    
    /*
     * setup Buttons as UIButtons
     */
    private func setupButtons() {
    
        
        
        let viewHeight = UIScreen.mainScreen().bounds.size.height ///self.view.frame.size.height + statusBarHeight
        let buttonSize = self.view.frame.size.width / 3
        
        
        
        self.buttonsView.frame = CGRectMake(0, viewHeight - SIZEOFBUTTONS_HEIGHT , buttonSize*3 , SIZEOFBUTTONS_HEIGHT)
        self.buttonsView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.buttonsView)
        

        let buttons = [self.clearBarButton, self.albumButton , self.doneBarButton]
        
        
        var index = 0
        for button in buttons {
        
            if let button = button {
                
                
                switch index {
                case 0:
                    button.addTarget(self, action: #selector(MainViewController.clearButtonPressed(_:)), forControlEvents: .TouchUpInside)
                    break
                case 1:
                    button.addTarget(self, action: #selector(MainViewController.albumButtonPressed(_:)), forControlEvents: .TouchUpInside)
                    break
                case 2:
                    button.addTarget(self, action: #selector(MainViewController.doneButtonPressed(_:)), forControlEvents: .TouchUpInside)
                    
                    break
                default:
                    break
                }

                button.frame = CGRectMake(buttonSize*CGFloat(index), 0 , buttonSize , SIZEOFBUTTONS_HEIGHT)
                self.buttonsView.addSubview(button)
                
                for subview in button.subviews {
                    subview.frame = button.bounds
                }
                
                index = index + 1
            }
            
        }
        
        
        
        selectionCounterView.frame = CGRectMake(buttonSize - SIZEOFBUTTONS_HEIGHT*0.6 , -SIZEOFBUTTONS_HEIGHT*0.6*0.25 , SIZEOFBUTTONS_HEIGHT*1, SIZEOFBUTTONS_HEIGHT*0.6)
        selectionCounterView.selectionCounterString = "0"
        selectionCounterView.backgroundColor = UIColor.clearColor()
        selectionCounterView.hidden = true
        self.buttonsView.addSubview(selectionCounterView)
        
        
    }
    
    /*
     * setup Buttons as UIToolBarButtons
     */
    private func setupToolBarButtons() {
    
    
        let viewHeight = UIScreen.mainScreen().bounds.size.height ///self.view.frame.size.height + statusBarHeight
        let buttonSize = self.view.frame.size.width / 3
        
        
        
        
        self.buttonsView.frame = CGRectMake(0, viewHeight - SIZEOFBUTTONS_HEIGHT , buttonSize*3 , SIZEOFBUTTONS_HEIGHT)
        self.buttonsView.backgroundColor = UIColor.clearColor()
        self.buttonsView.clipsToBounds = false
        self.view.addSubview(self.buttonsView)
        
        let toolbar : UIToolbar = UIToolbar.init(frame: self.buttonsView.bounds)
        self.buttonsView.addSubview(toolbar)
        
        
        toolbar.backgroundColor = self.settings.toolBarButtonsBackgroundColor
        toolbar.barTintColor = self.settings.toolBarButtonsBackgroundColor
        
        let item0 = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace , target: nil, action: nil)
        item0.width = 10.0
        
        
        let item1 = UIBarButtonItem.init(title: self.settings.buttonLabelTexts[0] , style: .Plain, target: self, action: #selector(clearButtonPressed(_:)))
            
        item1.tintColor = self.settings.toolBarButtonsFontColor
        
        let item2 = UIBarButtonItem.init(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        let item3 = UIBarButtonItem.init(title: self.settings.buttonLabelTexts[1] , style: .Plain, target: self, action: #selector(albumButtonPressed(_:)))
        item3.tintColor = self.settings.toolBarButtonsFontColor
        
        let item4 = UIBarButtonItem.init(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        let item5 = UIBarButtonItem.init(title: self.settings.buttonLabelTexts[2] , style: .Done, target: self, action: #selector(doneButtonPressed(_:)))
        item5.tintColor = self.settings.toolBarButtonsFontColor
        
        let item6 = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace , target: nil, action: nil)
        item6.width = 10.0
       
        
        toolbar.items = [item0,item1,item2,item3,item4,item5,item6]
        
        
        selectionCounterView.frame = CGRectMake(buttonSize - SIZEOFBUTTONS_HEIGHT*0.6 , -SIZEOFBUTTONS_HEIGHT*0.6*0.25 , SIZEOFBUTTONS_HEIGHT*1, SIZEOFBUTTONS_HEIGHT*0.6)
        selectionCounterView.selectionCounterString = "0"
        selectionCounterView.backgroundColor = UIColor.clearColor()
        selectionCounterView.hidden = true
        self.buttonsView.addSubview(selectionCounterView)
    
    
    }
    
    
    
    // MARK: Button Pressed Methods
    
    func clearButtonPressed(sender: AnyClass) {
        
        self.clearSelections()
      
        if let delegate = self.delegateRHImgPicker {
            
            delegate.RHImgPickerDidClearAllSelectedAssets()
        }
        
        
    }
    
    func albumButtonPressed(sender: AnyClass) {
        
        self.showAlbumSelection(!albumIsShowing)
    }
    
    
    func doneButtonPressed(sender: AnyClass) {
        
        guard let delegate = self.delegateRHImgPicker  else {
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        if  let photosDataSource = self.photosCollectionView.photosDataSource {
            delegate.RHImgPickerDidFinishPickingAssets(photosDataSource.selections)
        }
        else {
            delegate.RHImgPickerDidFinishPickingAssets([])
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    
    
    //MARK: Helper Methods
    
    func updateSelectionCounter() {
    
        guard let selections = self.photosCollectionView.photosDataSource?.selections else {
            
            selectionCounterView.selectionCounterString = "0"
            selectionCounterView.hidden = true
            
            return
        }
    
        if selections.count > 0 {
            
            selectionCounterView.selectionCounterString = String(selections.count)
            selectionCounterView.hidden = false
        }
        else {
        
            selectionCounterView.selectionCounterString = "0"
            selectionCounterView.hidden = true
        }
        
        
    
    }
    
    
    var albumIsShowing : Bool = false

    private func showAlbumSelection(show : Bool) {
    
        if  !show {
            
            albumIsShowing = false
            self.view.userInteractionEnabled = false
            

            
            UIView.animateWithDuration(0.25, animations: {
                
                self.photosCollectionView.frame = CGRectOffset(self.photosCollectionView.frame, 0, SIZEOFALBUMVIEW_HEIGHT*0.2)
                self.albumTableView.frame = CGRectOffset((self.albumTableView.frame), 0, SIZEOFALBUMVIEW_HEIGHT)
                
                }, completion: { (finish) in
                    
                    self.albumTableView.setContentOffset(CGPointZero, animated: false)
                    self.photosCollectionViewOverLayer.userInteractionEnabled = false
                    self.photosCollectionView.userInteractionEnabled = true
                    self.view.userInteractionEnabled = true
                    
                    if let gestureRecognizers = self.photosCollectionViewOverLayer.gestureRecognizers {
                        for gr in gestureRecognizers {
                            self.photosCollectionViewOverLayer.removeGestureRecognizer(gr)
                        }
                    }

            })
            
            
            
        } else {
            
            albumIsShowing = true
            
            self.view.userInteractionEnabled = false
            self.photosCollectionView.userInteractionEnabled = false
            self.photosCollectionViewOverLayer.userInteractionEnabled = true
            self.albumTableView.reloadData()
            
            
            
            UIView.animateWithDuration(0.25, animations: {
                
                self.photosCollectionView.frame = CGRectOffset(self.photosCollectionView.frame, 0, -SIZEOFALBUMVIEW_HEIGHT*0.2)
                self.albumTableView.frame = CGRectOffset((self.albumTableView.frame), 0, -SIZEOFALBUMVIEW_HEIGHT)
                
                
                }, completion: { (finish) in
                    
                    
                    
                    if  let indexPath : NSIndexPath = self.albumTableView.indexPathForSelectedRow {
                        self.albumTableView.deselectRowAtIndexPath(indexPath, animated: true)
                    }
                    
                    self.view.userInteractionEnabled = true
                    
                    
                    
                    if let gestureRecognizers = self.photosCollectionViewOverLayer.gestureRecognizers {
                        for gr in gestureRecognizers {
                            self.photosCollectionViewOverLayer.removeGestureRecognizer(gr)
                        }
                    }

                   
            
                    
                    let tapRecognizer = UITapGestureRecognizer()
                    tapRecognizer.numberOfTapsRequired = 1
                    tapRecognizer.addTarget(self, action: #selector(MainViewController.tapOnPhotoView))
                    
                    self.photosCollectionViewOverLayer.addGestureRecognizer(tapRecognizer)
                    
                    
                    let swipRecognizer = UISwipeGestureRecognizer()
                    swipRecognizer.direction = .Down
                    swipRecognizer.addTarget(self, action: #selector(MainViewController.tapOnPhotoView))
                    self.photosCollectionViewOverLayer.addGestureRecognizer(swipRecognizer)
                    
                    
                    
            })
            
            
        }
        
        
    }
    
    func tapOnPhotoView() {
    
        if albumIsShowing {
            self.showAlbumSelection(false)
        }
        
        
        if let gestureRecognizers = self.photosCollectionViewOverLayer.gestureRecognizers {
            for gr in gestureRecognizers {
                self.photosCollectionViewOverLayer.removeGestureRecognizer(gr)
            }
        }

    }
    
    
    func clearSelections() {
    
        guard let photosDataSource = self.photosCollectionView.photosDataSource else { return }
        
        // Deselect asset
        if photosDataSource.selections.count > 0 {
            
            self.photosCollectionView.deselectVisableCellsFromCollectionViewAnimated(true)
            self.photosCollectionView.deselectAllCellsAnimated(false)
            photosDataSource.selections.removeAll()
        }
        
        updateSelectionCounter()
        

    
    
    }
  

    
    
    
    //MARK: - AlbumTableViewDelegate
    
    func albumTableViewDidSelect(album: PHAssetCollection) {
        // load data for selected album
        
        
        initializePhotosDataSource(album)
        self.photosCollectionView.synchronizeCollectionView()
        self.showAlbumSelection(false)
    }
    
    
    func albumTableViewDidSelectTheSameAlbum() {
        
        self.showAlbumSelection(false)
    }
    
    
    
    //MARK: - PhotosCollectionViewDelegate
    
    func photosCollectionViewDelegateDidSelect(asset: PHAsset) {
        
        
        updateSelectionCounter()
    }
    
    func photosCollectionViewDelegateDidDeselect(asset: PHAsset) {
        
        
        updateSelectionCounter()
    }
    
    
    
    
    
    //MARK: - Album Photo Data Sync functions
    
    func initializePhotosDataSource(album: PHAssetCollection, selections: PHFetchResult? = nil) {
        // Set up a photo data source with album
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.Image.rawValue)
        
        
        initializePhotosDataSourceWithFetchResult(PHAsset.fetchAssetsInAssetCollection(album, options: fetchOptions), selections: selections)
    }
    
 
    func initializePhotosDataSourceWithFetchResult(fetchResult: PHFetchResult, selections: PHFetchResult? = nil) {
        let newDataSource = PhotoCollectionViewDataSource(fetchResult: fetchResult, selections: selections, settings: settings)
        
        // Transfer image size
        // TODO: Move image size to settings
        if let photosDataSource = self.photosCollectionView.photosDataSource {
            newDataSource.imageSize = photosDataSource.imageSize
            newDataSource.selections = photosDataSource.selections
        }
        
        /// to fix a crash -> set the photos collection view scroll position to top
        self.photosCollectionView.setContentOffset(CGPointZero, animated: false)
        
        
        self.photosCollectionView.photosDataSource = newDataSource
        // Hook up data source
        self.photosCollectionView.dataSource = newDataSource
        
        
       
    }
}





// MARK: -  UINavigationControllerDelegate
extension MainViewController: UINavigationControllerDelegate {
    

    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .Push {
            return expandAnimator
        } else {
            return shrinkAnimator
        }
    }
    
    
    
}



// MARK: -  LongPressOnPhotoCollection

extension MainViewController {

    func captureScreen() -> UIImage? {
        if let window = UIApplication.sharedApplication().windows.first {
            UIGraphicsBeginImageContextWithOptions(window.frame.size, window.opaque, 0.0)
            window.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image;
        }
       
        return nil
        
    }

    func setupLongPressOnPhotoCollection() {
    
        // Add long press recognizer
        let longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                               action: #selector(MainViewController.collectionViewLongPressed(_:)))
        
        longPressRecognizer.minimumPressDuration = 0.5
    
        photosCollectionView.addGestureRecognizer(longPressRecognizer)
        
    
    }



    func collectionViewLongPressed(sender: UIGestureRecognizer) {
        
        let collectionView = self.photosCollectionView
        
        if sender.state == .Began {
            // Disable recognizer while we are figuring out location and pushing preview
            sender.enabled = false
            collectionView.userInteractionEnabled = false
            
            // Calculate which index path long press came from
            let location = sender.locationInView(collectionView)
            let indexPath = collectionView.indexPathForItemAtPoint(location)
            
            if let vc = previewViewContoller , let indexPath = indexPath, let cell = collectionView.cellForItemAtIndexPath(indexPath) as? PhotoCell, let asset = cell.asset {
                // Setup fetch options to be synchronous
                let options = PHImageRequestOptions()
                options.synchronous = true
                
                // Load image for preview
                if let imageView = vc.imageView {
                    PHCachingImageManager.defaultManager().requestImageForAsset(asset, targetSize:imageView.frame.size, contentMode: .AspectFit, options: options) { (result, _) in
                        imageView.image = result
                    }
                }
                
                // Setup animation
                expandAnimator.sourceImageView = cell.imageView
                expandAnimator.destinationImageView = vc.imageView
                shrinkAnimator.sourceImageView = vc.imageView
                shrinkAnimator.destinationImageView = cell.imageView

                
                // set background for preview viewcontroller
                vc.backgroundImageView?.image = captureScreen()
                
                
                // push viewcontroller
                navigationController?.pushViewController(vc, animated: true)
            }
            
            // Re-enable recognizer, after animation is done
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(expandAnimator.transitionDuration(nil) * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                sender.enabled = true
                collectionView.userInteractionEnabled = true
            })
        }
    }

}

