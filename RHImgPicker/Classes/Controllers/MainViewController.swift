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

  
    
    
    var settings: RHImgPickerSettings = RHSettings.sharedInstance
    
    fileprivate var delegateRHImgPicker : RHImgPickerDelegate?
    
    
    let expandAnimator = RHAnimator()
    let shrinkAnimator = RHAnimator()
    
    fileprivate var defaultSelections: PHFetchResult<AnyObject>?
    fileprivate var fetchResults : [PHFetchResult<AnyObject>]
    
    
    fileprivate let albumTableView : AlbumTableView = AlbumTableView()
    
    fileprivate let photosCollectionViewOverLayer : UIView = UIView()
    fileprivate let photosCollectionView : PhotosCollectionView = PhotosCollectionView()
    
    fileprivate let proxyViewForStatusBar : UIView = UIView()
    
    fileprivate lazy var previewViewContoller: PreviewViewController? = {
        return PreviewViewController(nibName: nil, bundle: nil)
    }()
    
    
     //MARK: -
    
    
    
    
    let TAG = "PhotosViewController"
    func log(_ message : String) {
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
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    
    
    //MARK: - init Methods
    
    
    required init(fetchResults: [PHFetchResult<AnyObject>],
             defaultSelections: PHFetchResult<AnyObject>? = nil,
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
    fileprivate func setup(_ frame : CGRect) {
        
        
        // hid navigation bar
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = self.settings.backgroundColor
        
        
        // Setup views
        
        
        
        let statusBarHeight : CGFloat = 0       ///UIApplication.sharedApplication().statusBarFrame.size.height
        
   
        
        
        photosCollectionView.photosCollectionViewDelegate = self
        photosCollectionView.setup(CGRect(x: 0, y: statusBarHeight, width: frame.size.width, height: frame.size.height - statusBarHeight - SIZEOFBUTTONS_HEIGHT))      ///(photosView.bounds)
        photosCollectionView.clipsToBounds = false
        photosCollectionView.scrollsToTop = true
        photosCollectionView.backgroundColor =  self.settings.backgroundColor
        self.view.addSubview(photosCollectionView)
        
        
        photosCollectionViewOverLayer.frame = photosCollectionView.bounds
        photosCollectionViewOverLayer.clipsToBounds = false
        photosCollectionViewOverLayer.backgroundColor = UIColor.clear
        photosCollectionViewOverLayer.isUserInteractionEnabled = false
        self.view.addSubview(photosCollectionViewOverLayer)
        
        
        
        
        
 
        
        let albumFrame = CGRect(x: 0, y: frame.size.height, width: frame.size.width, height: SIZEOFALBUMVIEW_HEIGHT - SIZEOFBUTTONS_HEIGHT)
        
        albumTableView.albumTableViewDelegate = self
        albumTableView.backgroundColor = UIColor.clear
        albumTableView.setup(albumFrame, albumsDataSource: AlbumTableViewDataSource(fetchResults: self.fetchResults, settings: self.settings))
        albumTableView.scrollsToTop = false
        self.view.addSubview(albumTableView)
        
        

        
        
        
        
        
        // proxy view for status bar
        proxyViewForStatusBar.frame = CGRect(x: 0, y: 0,width: self.view.frame.size.width, height: UIApplication.shared.statusBarFrame.size.height)
        proxyViewForStatusBar.backgroundColor = self.settings.backgroundColor
        self.view.addSubview(proxyViewForStatusBar)
        
 
        
        // Set navigation controller delegate
        navigationController?.delegate = self
      
        
        self.setupToolBarButtons()
        
        
        // init photos collection for first album
        if let album = self.albumTableView.albumsDataSource!.fetchResults.first?.firstObject as? PHAssetCollection {
            initializePhotosDataSource(album, selections: defaultSelections)
            self.photosCollectionView.synchronizeCollectionView()
        }

        
        
        
        
    }
    
    
    let buttonsView : UIView = UIView()
    let selectionCounterView : RHSelectionCounterView = RHSelectionCounterView()
    
    
    
    /*
     * setup Buttons - UIToolBarButtons
     */
    fileprivate func setupToolBarButtons() {
    
    
        let viewHeight = self.view.frame.size.height ///self.view.frame.size.height + statusBarHeight
        let buttonSize = self.view.frame.size.width / 3
        
        
        self.buttonsView.frame = CGRect(x: 0, y: viewHeight - SIZEOFBUTTONS_HEIGHT , width: buttonSize*3 , height: SIZEOFBUTTONS_HEIGHT)
        self.buttonsView.backgroundColor = UIColor.clear
        self.buttonsView.clipsToBounds = false
        self.view.addSubview(self.buttonsView)
        
        let toolbar : UIToolbar = UIToolbar.init(frame: self.buttonsView.bounds)
        self.buttonsView.addSubview(toolbar)
        
        
        toolbar.backgroundColor = self.settings.toolBarButtonsBackgroundColor
        toolbar.barTintColor = self.settings.toolBarButtonsBackgroundColor
        
        let item0 = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace , target: nil, action: nil)
        item0.width = 10.0
        
        
        let item1 = UIBarButtonItem.init(title: self.settings.buttonLabelTexts[0] , style: .plain, target: self, action: #selector(clearButtonPressed(_:)))
            
        item1.tintColor = self.settings.toolBarButtonsFontColor
        
        let item2 = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let item3 = UIBarButtonItem.init(title: self.settings.buttonLabelTexts[1] , style: .plain, target: self, action: #selector(albumButtonPressed(_:)))
        item3.tintColor = self.settings.toolBarButtonsFontColor
        
        let item4 = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let item5 = UIBarButtonItem.init(title: self.settings.buttonLabelTexts[2] , style: .done, target: self, action: #selector(doneButtonPressed(_:)))
        item5.tintColor = self.settings.toolBarButtonsFontColor
        
        let item6 = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace , target: nil, action: nil)
        item6.width = 10.0
       
        
        toolbar.items = [item0,item1,item2,item3,item4,item5,item6]
        
        
        selectionCounterView.frame = CGRect(x: buttonSize - SIZEOFBUTTONS_HEIGHT*0.6 , y: -SIZEOFBUTTONS_HEIGHT*0.6*0.25 , width: SIZEOFBUTTONS_HEIGHT*1, height: SIZEOFBUTTONS_HEIGHT*0.6)
        selectionCounterView.selectionCounterString = "0"
        selectionCounterView.backgroundColor = UIColor.clear
        selectionCounterView.isHidden = true
        self.buttonsView.addSubview(selectionCounterView)
    
    
    }
    
    
    
    // MARK: Button Pressed Methods
    
    func clearButtonPressed(_ sender: AnyClass) {
        
        self.clearSelections()
      
        if let delegate = self.delegateRHImgPicker {
            
            delegate.RHImgPickerDidClearAllSelectedAssets()
        }
        
        
    }
    
    func albumButtonPressed(_ sender: AnyClass) {
        
        self.showAlbumSelection(!albumIsShowing)
    }
    
    
    func doneButtonPressed(_ sender: AnyClass) {
        
        guard let delegate = self.delegateRHImgPicker  else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        if  let photosDataSource = self.photosCollectionView.photosDataSource {
            delegate.RHImgPickerDidFinishPickingAssets(photosDataSource.selections)
        }
        else {
            delegate.RHImgPickerDidFinishPickingAssets([])
        }
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
    //MARK: Helper Methods
    
    func updateSelectionCounter() {
    
        guard let selections = self.photosCollectionView.photosDataSource?.selections else {
            
            selectionCounterView.selectionCounterString = "0"
            selectionCounterView.isHidden = true
            
            return
        }
    
        if selections.count > 0 {
            
            selectionCounterView.selectionCounterString = String(selections.count)
            selectionCounterView.isHidden = false
        }
        else {
        
            selectionCounterView.selectionCounterString = "0"
            selectionCounterView.isHidden = true
        }
        
        
    
    }
    
    
    var albumIsShowing : Bool = false

    fileprivate func showAlbumSelection(_ show : Bool) {
    
        if  !show {
            
            albumIsShowing = false
            self.view.isUserInteractionEnabled = false
            

            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.photosCollectionView.frame = self.photosCollectionView.frame.offsetBy(dx: 0, dy: SIZEOFALBUMVIEW_HEIGHT*0.2)
                self.albumTableView.frame = (self.albumTableView.frame).offsetBy(dx: 0, dy: SIZEOFALBUMVIEW_HEIGHT)
                
                }, completion: { (finish) in
                    
                    self.albumTableView.setContentOffset(CGPoint.zero, animated: false)
                    self.photosCollectionViewOverLayer.isUserInteractionEnabled = false
                    self.photosCollectionView.isUserInteractionEnabled = true
                    self.view.isUserInteractionEnabled = true
                    
                    if let gestureRecognizers = self.photosCollectionViewOverLayer.gestureRecognizers {
                        for gr in gestureRecognizers {
                            self.photosCollectionViewOverLayer.removeGestureRecognizer(gr)
                        }
                    }

            })
            
            
            
        } else {
            
            albumIsShowing = true
            
            self.view.isUserInteractionEnabled = false
            self.photosCollectionView.isUserInteractionEnabled = false
            self.photosCollectionViewOverLayer.isUserInteractionEnabled = true
            self.albumTableView.reloadData()
            
            
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.photosCollectionView.frame = self.photosCollectionView.frame.offsetBy(dx: 0, dy: -SIZEOFALBUMVIEW_HEIGHT*0.2)
                self.albumTableView.frame = (self.albumTableView.frame).offsetBy(dx: 0, dy: -SIZEOFALBUMVIEW_HEIGHT)
                
                
                }, completion: { (finish) in
                    
                    
                    
                    if  let indexPath : IndexPath = self.albumTableView.indexPathForSelectedRow {
                        self.albumTableView.deselectRow(at: indexPath, animated: true)
                    }
                    
                    self.view.isUserInteractionEnabled = true
                    
                    
                    
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
                    swipRecognizer.direction = .down
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
            
            self.photosCollectionView.clearSelectdCells()
            photosDataSource.selections.removeAll()
        }
        
        self.updateSelectionCounter()
        

    
    
    }
  

    
    
    
    //MARK: - AlbumTableViewDelegate
    
    func albumTableViewDidSelect(_ album: PHAssetCollection) {
        // load data for selected album
        
        
        initializePhotosDataSource(album)
        self.photosCollectionView.synchronizeCollectionView()
        self.showAlbumSelection(false)
    }
    
    
    func albumTableViewDidSelectTheSameAlbum() {
        
        self.showAlbumSelection(false)
    }
    
    
    
    //MARK: - PhotosCollectionViewDelegate
    
    func photosCollectionViewDelegateDidSelect(_ asset: PHAsset) {
        
        
        self.updateSelectionCounter()
    }
    
    func photosCollectionViewDelegateDidDeselect(_ asset: PHAsset) {
        
        
        self.updateSelectionCounter()
    }
    
    
    
    
    
    //MARK: - Album Photo Data Sync functions
    
    func initializePhotosDataSource(_ album: PHAssetCollection, selections: PHFetchResult<AnyObject>? = nil) {
        // Set up a photo data source with album
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        
        
        initializePhotosDataSourceWithFetchResult(PHAsset.fetchAssets(in: album, options: fetchOptions) as! PHFetchResult<AnyObject>, selections: selections)
    }
    
 
    func initializePhotosDataSourceWithFetchResult(_ fetchResult: PHFetchResult<AnyObject>, selections: PHFetchResult<AnyObject>? = nil) {
        let newDataSource = PhotoCollectionViewDataSource(fetchResult: fetchResult, selections: selections, settings: settings)
        
        // Transfer image size
        // TODO: Move image size to settings
        if let photosDataSource = self.photosCollectionView.photosDataSource {
            newDataSource.imageSize = photosDataSource.imageSize
            newDataSource.selections = photosDataSource.selections
        }
        
        /// to fix a crash -> set the photos collection view scroll position to top
        self.photosCollectionView.setContentOffset(CGPoint.zero, animated: false)
        
        
        self.photosCollectionView.photosDataSource = newDataSource
        // Hook up data source
        self.photosCollectionView.dataSource = newDataSource
        
        
       
    }
}





// MARK: -  UINavigationControllerDelegate
extension MainViewController: UINavigationControllerDelegate {
    

    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return expandAnimator
        } else {
            return shrinkAnimator
        }
    }
    
    
    
}



// MARK: -  LongPressOnPhotoCollection

extension MainViewController {

    func captureScreen() -> UIImage? {
        if let window = UIApplication.shared.windows.first {
            UIGraphicsBeginImageContextWithOptions(window.frame.size, window.isOpaque, 0.0)
            window.layer.render(in: UIGraphicsGetCurrentContext()!)
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



    func collectionViewLongPressed(_ sender: UIGestureRecognizer) {
        
        let collectionView = self.photosCollectionView
        
        if sender.state == .began {
            // Disable recognizer while we are figuring out location and pushing preview
            sender.isEnabled = false
            collectionView.isUserInteractionEnabled = false
            
            // Calculate which index path long press came from
            let location = sender.location(in: collectionView)
            let indexPath = collectionView.indexPathForItem(at: location)
            
            if let vc = previewViewContoller , let indexPath = indexPath, let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell, let asset = cell.asset {
                // Setup fetch options to be synchronous
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                // Load image for preview
                if let imageView = vc.imageView {
                    PHCachingImageManager.default().requestImage(for: asset, targetSize:imageView.frame.size, contentMode: .aspectFit, options: options) { (result, _) in
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
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(expandAnimator.transitionDuration(using: nil) * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
                sender.isEnabled = true
                collectionView.isUserInteractionEnabled = true
            })
        }
    }

}

