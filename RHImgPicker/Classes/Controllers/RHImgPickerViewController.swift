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



public class RHImgPickerViewController: UINavigationController {

    /**
     Bundle.
     */
    static let bundle: NSBundle = NSBundle.init(forClass: RHImgPickerViewController.self)
    
    
    
    /**
     authorization Photos.
     */
    class func authorize(status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus(), fromViewController: UIViewController, completion: (authorized: Bool) -> Void) {
        switch status {
        case .Authorized:
            // We are authorized. Run block
            completion(authorized: true)
        case .NotDetermined:
            // Ask user for permission
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.authorize(status, fromViewController: fromViewController, completion: completion)
                })
            })
        default: ()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            completion(authorized: false)
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
     https://www.youtube.com/watch?v=dQw4w9WgXcQ
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    
    
    
    
    /**
     Object that keeps settings for the picker.
     */
    public var settings: RHImgPickerSettings = RHSettings.sharedInstance

    
    
    /**
     Done button.
     */
    public var doneButton: UIButton?
    public var doneButtonLabel : UILabel?

    /**
     Cancel button
     */
    public var clearButton: UIButton?
    public var clearButtonLabel : UILabel?
    
    
    /**
     Album button
     */
    public var albumButton: UIButton?
    public var albumButtonLabel : UILabel?
    
    
    
    
    
    
    
    /**
     RHImgPickerDelegate protocol.
     */
    public var delegateRImgPicker : RHImgPickerDelegate?
    
    /**
     Default selections
     */
    public var defaultSelections: PHFetchResult?
    
    
    /**
     Fetch results.
     */
    public lazy var fetchResults: [PHFetchResult] = {
        
        let fetchOptions = PHFetchOptions()
        
        // Camera roll fetch result
        let cameraRollResult = PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype: .SmartAlbumUserLibrary, options: fetchOptions)
        
        // Albums fetch result
        let albumResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        
        return [cameraRollResult, albumResult]
    }()
    

    
    
    
    
    /**
     PhotosViewController.
     */
    lazy var mainViewController: MainViewController = {
        
        
        let vc = MainViewController(fetchResults: self.fetchResults,
                                      defaultSelections: self.defaultSelections,
                                      settings: self.settings,
                                      delegate: self.delegateRImgPicker)
        

        
        if !self.settings.useToolBarButtons {
            
            if self.clearButton == nil {
                self.clearButton = UIButton.init(type: UIButtonType.Custom)
            }
            if self.albumButton == nil {
                self.albumButton = UIButton.init(type: UIButtonType.Custom)
            }
            if self.doneButton == nil {
                self.doneButton = UIButton.init(type: UIButtonType.Custom)
            }
            
            if self.clearButtonLabel == nil {
                self.clearButtonLabel  = UILabel()
            }
            if self.albumButtonLabel == nil {
                self.albumButtonLabel  = UILabel()
            }
            if self.doneButtonLabel == nil {
                self.doneButtonLabel  = UILabel()
            }
            
            
            
            let buttonLbls = [self.clearButtonLabel,self.albumButtonLabel,self.doneButtonLabel ]
            let buttons = [self.clearButton ,self.albumButton,self.doneButton  ]
            
            var index = 0
            for button in buttons {
                
                if let button = button {
                    
                    button.backgroundColor = self.settings.buttonColors[index]
                    button.tag = RHBT_TAG
                    index = index + 1
                }
                
            }
            
            index = 0
            for buttonLbl in buttonLbls {
                
                if let buttonLbl = buttonLbl {
                    
                    buttonLbl.text = self.settings.buttonLabelTexts[index]
                    buttonLbl.font = self.settings.buttonLabelFont
                    buttonLbl.textColor = self.settings.buttonLabelFontColors[index]
                    buttonLbl.backgroundColor = self.settings.buttonHighlightColors[index].colorWithAlphaComponent(0.0)
                    buttonLbl.textAlignment = .Center
                    buttonLbl.numberOfLines = 1
                    buttonLbl.tag = RHBT_TAG
                    index = index + 1
                }
            }
            
            self.clearButton!.addSubview(self.clearButtonLabel!)
            self.albumButton!.addSubview(self.albumButtonLabel!)
            self.doneButton!.addSubview(self.doneButtonLabel!)
            
            vc.doneBarButton = self.doneButton!
            vc.clearBarButton =  self.clearButton!
            vc.albumButton = self.albumButton!
            
        }
    
        return vc
    }()
    
    
    
    
    
    var mainViewControllerDidLoad : Bool = false
    override public func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = self.settings.backgroundColor
        
        // Make sure we really are authorized
        if PHPhotoLibrary.authorizationStatus() == .Authorized {
            mainViewControllerDidLoad = true
            setViewControllers([mainViewController], animated: false)
        }

    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    
    
    public func clearSelection() {
    
        if mainViewControllerDidLoad {
            
            mainViewController.clearSelections()
            
        }
        
    
    
    }
    
    
   
    
    
}






