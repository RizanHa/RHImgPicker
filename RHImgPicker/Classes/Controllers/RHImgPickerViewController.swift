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
//  RHImgPickerViewController.swift
//  Pods
//
//  Created by rizan on 26/08/2016.
//
//

import UIKit
import Photos



open class RHImgPickerViewController: UINavigationController {

    /**
     Bundle.
     */
    static let bundle: Bundle = Bundle.init(for: RHImgPickerViewController.self)
    
    
    
    /**
     authorization Photos.
     */
    class func authorize(_ status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus(), fromViewController: UIViewController, completion: @escaping (_ authorized: Bool) -> Void) {
        switch status {
        case .authorized:
            // We are authorized. Run block
            completion(true)
        case .notDetermined:
            // Ask user for permission
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    self.authorize(status, fromViewController: fromViewController, completion: completion)
                })
            })
        default: ()
        DispatchQueue.main.async(execute: { () -> Void in
            completion(false)
        })
        }
    }

    
    
    
    /**
     Sets up an classic image picker with results from camera roll and albums
     */
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    /**
    ...
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    
    
    
    
    /**
     Object that keeps settings for the picker.
     */
    open var settings: RHImgPickerSettings = RHSettings.sharedInstance

    
    
   
    
    
    
    /**
     RHImgPickerDelegate protocol.
     */
    open var delegateRImgPicker : RHImgPickerDelegate?
    
    /**
     Default selections
     */
    open var defaultSelections: PHFetchResult<AnyObject>?
    
    
    /**
     Fetch results.
     */
    open lazy var fetchResults: [PHFetchResult<AnyObject>] = { () -> [PHFetchResult<AnyObject>] in
        
        let fetchOptions = PHFetchOptions()
    
        
        guard
            // Camera roll fetch result
            let cameraRollResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: fetchOptions) as? PHFetchResult<AnyObject>,
            
            // Albums fetch result
            let albumResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions) as? PHFetchResult<AnyObject>
        
            
            
        else { return [] }

        
         
        
        return [cameraRollResult , albumResult]
        
        
        
    }()
    

    
    
    
    
    /**
     PhotosViewController.
     */
    lazy var mainViewController: MainViewController = {
        
        let vc = MainViewController(fetchResults: self.fetchResults,
                                      defaultSelections: self.defaultSelections,
                                      settings: self.settings,
                                      delegate: self.delegateRImgPicker)
        
        return vc
    }()
    
    
    
    
    
    var mainViewControllerDidLoad : Bool = false
    override open func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = self.settings.backgroundColor
        
        // Make sure we really are authorized
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            mainViewControllerDidLoad = true
            setViewControllers([mainViewController], animated: false)
        }

    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    
    // clear selections from the module
    open func clearSelection() {
    
        if mainViewControllerDidLoad {
            mainViewController.clearSelections()
        }
    }
    
    
   
    
    
}






