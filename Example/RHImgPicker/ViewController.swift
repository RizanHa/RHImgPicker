//
//  ViewController.swift
//  RHImgPicker
//
//  Created by Rizan Hamza on 08/31/2016.
//  Copyright (c) 2016 Rizan Hamza. All rights reserved.
//


import UIKit

import RHImgPicker
import Photos


class ViewController: UIViewController, RHImgPickerDelegate {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupRHImgPicker()
        setupDemoView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    
    
    
    private let imgPicker = RHImgPickerViewController()
    
    
    private func setupRHImgPicker() {
        
        imgPicker.settings.maxNumberOfSelections = 1
        
        imgPicker.settings.buttonHighlightColors = [UIColor.whiteColor(), UIColor.blackColor(), UIColor.redColor()]
        
        imgPicker.settings.useToolBarButtons = true
        
        
        imgPicker.settings.setAlbumCellAnimation { (layer) in
            
            
            let PI : CGFloat = 3.145
            var rotation : CATransform3D
            rotation = CATransform3DMakeRotation( (90.0*PI)/180, 0.0, 0.7, 0.4)
            rotation.m34 = 1.0 / -600;
            
            layer.shadowColor = UIColor.blackColor().CGColor
            layer.shadowOffset = CGSizeMake(10, 10);
            layer.opacity = 0;
            
            layer.transform = rotation;
            layer.anchorPoint = CGPointMake(0, 0.5);
            
            UIView.animateWithDuration(0.5, animations: {
                
                layer.transform = CATransform3DIdentity;
                layer.opacity = 1;
                layer.shadowOffset = CGSizeMake(0, 0);
                
                }, completion: { (finish) in
                    
                    layer.transform = CATransform3DIdentity;
                    
            })
            
            
        }
        
        
    }
    
    
    private let imgViews : [UIImageView] = [UIImageView(),UIImageView(),UIImageView(),UIImageView(),UIImageView(),UIImageView()]    /// 6 UIImageViews
    private func setupDemoView() {
        
        
        
        self.view.backgroundColor = UIColor.darkGrayColor()
        
        
        let offset : CGFloat = UIScreen.mainScreen().bounds.size.height * 0.2
        
        let maxImgsInARow : CGFloat = 3
        
        let imgSizeXY : CGFloat = UIScreen.mainScreen().bounds.size.width / maxImgsInARow
        
        
        var rowIndex : CGFloat = 0
        var columnIndex : CGFloat = 0
        
        var index = 0
        
        for imgView in imgViews {
            
            imgView.frame = CGRectMake(imgSizeXY*columnIndex, imgSizeXY*rowIndex + offset, imgSizeXY, imgSizeXY)
            imgView.backgroundColor = UIColor.clearColor()
            imgView.contentMode = .ScaleAspectFit
            self.view.addSubview(imgView)
            
            
            let lbl : UILabel = UILabel(frame: imgView.bounds)
            lbl.text = String(index+1)
            lbl.textColor = UIColor.lightTextColor()
            lbl.frame = CGRectOffset(lbl.frame, 0, -lbl.frame.size.height*0.55 )
            lbl.textAlignment = .Center
            imgView.addSubview(lbl)
            
            index = index + 1
            columnIndex = columnIndex + 1
            
            if columnIndex == maxImgsInARow {
                
                columnIndex = 0
                rowIndex  = rowIndex + 1.5
            }
        }
    }
    
    
    
    @IBAction func buttonDidPressed(sender: AnyObject) {
        
        self.rh_presentRHImgPickerController(imgPicker, delegate: self, animated: true) {
            // done...
            
        }
    }
    
    
    
    private func getAssetThumbnail(asset: PHAsset) -> UIImage {
        
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        option.synchronous = true
        var thumbnail = UIImage()
        let maxSizeImg : Double = 200
        
        manager.requestImageForAsset(asset, targetSize: CGSize(width: Int(maxSizeImg), height: Int(maxSizeImg) ), contentMode: .AspectFit , options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    
    
    @IBAction func selectionLimitDidChange(sender: AnyObject) {
        
        if let sender : UISegmentedControl = sender as? UISegmentedControl  {
            
            if let value =  sender.titleForSegmentAtIndex(sender.selectedSegmentIndex), let intValue = Int(value) {
                imgPicker.settings.maxNumberOfSelections = intValue
                imgPicker.clearSelection()
            }
            
            
            
            
        }
        
        
    }
    
    
    //MARK: - RHImgPicker Delegate
    
    func RHImgPickerDidFinishPickingAssets(assets: [PHAsset]) {
        
        // clear all
        for imgView in imgViews {
            imgView.image = nil
        }
        
        // update with curent selection
        var curentIndex = 0
        for item in assets {
            if curentIndex < imgViews.count {
                if let img : UIImage = self.getAssetThumbnail(item) {
                    imgViews[curentIndex].image = img
                    curentIndex = curentIndex + 1
                }
            }
        }
    }
    
    
    func RHImgPickerDidClearAllSelectedAssets() {
        
        
    }
    
    func RHImgPickerDidSelectAsset(assets: PHAsset) {
        
        
    }
    
    func RHImgPickerDidDeselectAsset(assets: PHAsset) {
        
        
    }
    
    
}

