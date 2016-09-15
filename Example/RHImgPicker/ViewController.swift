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
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    
    
    
    fileprivate let imgPicker = RHImgPickerViewController()
    
    
    fileprivate func setupRHImgPicker() {
        
        
        imgPicker.settings.maxNumberOfSelections = 1
        ///imgPicker.settings.selectionCharacter = Character(" ")
        
        imgPicker.settings.setAlbumCellAnimation { (layer) in
            
            
            let PI : CGFloat = 3.145
            var rotation : CATransform3D
            rotation = CATransform3DMakeRotation( (90.0*PI)/180, 0.0, 0.7, 0.4)
            rotation.m34 = 1.0 / -600;
            
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 10, height: 10);
            layer.opacity = 0;
            
            layer.transform = rotation;
            layer.anchorPoint = CGPoint(x: 0, y: 0.5);
            
            UIView.animate(withDuration: 0.5, animations: {
                
                layer.transform = CATransform3DIdentity;
                layer.opacity = 1;
                layer.shadowOffset = CGSize(width: 0, height: 0);
                
                }, completion: { (finish) in
                    
                    layer.transform = CATransform3DIdentity;
                    
            })
            
            
        }
        
        
    }
    
    
    fileprivate let imgViews : [UIImageView] = [UIImageView(),UIImageView(),UIImageView(),UIImageView(),UIImageView(),UIImageView()]    /// 6 UIImageViews
    fileprivate func setupDemoView() {
        
        
        
        self.view.backgroundColor = UIColor.darkGray
        
        
        let offset : CGFloat = UIScreen.main.bounds.size.height * 0.2
        
        let maxImgsInARow : CGFloat = 3
        
        let imgSizeXY : CGFloat = UIScreen.main.bounds.size.width / maxImgsInARow
        
        
        var rowIndex : CGFloat = 0
        var columnIndex : CGFloat = 0
        
        var index = 0
        
        for imgView in imgViews {
            
            imgView.frame = CGRect(x: imgSizeXY*columnIndex, y: imgSizeXY*rowIndex + offset, width: imgSizeXY, height: imgSizeXY)
            imgView.backgroundColor = UIColor.clear
            imgView.contentMode = .scaleAspectFit
            imgView.layer.borderWidth = 1
            imgView.layer.borderColor = UIColor.lightText.cgColor
            self.view.addSubview(imgView)
            
            
            let lbl : UILabel = UILabel(frame: imgView.bounds)
            lbl.text = String(index+1)
            lbl.textColor = UIColor.lightText
            lbl.frame = lbl.frame.offsetBy(dx: 0, dy: -lbl.frame.size.height*0.6 )
            lbl.textAlignment = .center
            imgView.addSubview(lbl)
            
            index = index + 1
            columnIndex = columnIndex + 1
            
            if columnIndex == maxImgsInARow {
                
                columnIndex = 0
                rowIndex  = rowIndex + 1.5
            }
        }
    }
    
    
    
    @IBAction func buttonDidPressed(_ sender: AnyObject) {
        
        self.rh_presentRHImgPickerController(imgPicker, delegate: self, animated: true) {
            // done...
            
        }
    }
    
    
    
    fileprivate func getAssetThumbnail(_ asset: PHAsset) -> UIImage {
        
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        var thumbnail = UIImage()
        let maxSizeImg : Double = 200
        
        manager.requestImage(for: asset, targetSize: CGSize(width: Int(maxSizeImg), height: Int(maxSizeImg) ), contentMode: .aspectFit , options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    
    
    @IBAction func selectionLimitDidChange(_ sender: AnyObject) {
        
        if let sender : UISegmentedControl = sender as? UISegmentedControl  {
            
            if let value =  sender.titleForSegment(at: sender.selectedSegmentIndex), let intValue = Int(value) {
                imgPicker.settings.maxNumberOfSelections = intValue
                imgPicker.clearSelection()
            }
            
            
            
            
        }
        
        
    }
    
    
    //MARK: - RHImgPicker Delegate
    
    
    
    func RHImgPickerDidFinishPickingAssets(_ assets: [PHAsset]) {
        
        // clear all
        for imgView in imgViews {
            imgView.image = nil
        }
        
        // update with curent selection

        for (curentIndex ,item ) in assets.enumerated() {
            if curentIndex < imgViews.count {
                let img : UIImage = self.getAssetThumbnail(item)
                imgViews[curentIndex].image = img
            }
        }
    }
    
    
    func RHImgPickerDidClearAllSelectedAssets() {
        
        
    }
    
    func RHImgPickerDidSelectAsset(_ asset: PHAsset) {
        
        
    }
    
    func RHImgPickerDidDeselectAsset(_ asset: PHAsset) {
        
        
    }
    
    
}

