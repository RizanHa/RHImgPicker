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
//  PhotoCollectionViewDataSource.swift
//  Pods
//
//  Created by rizan on 26/08/2016.
//
//

import UIKit
import Photos

final class PhotoCollectionViewDataSource : NSObject, UICollectionViewDataSource, UICollectionViewDelegate {

    
    
    class func registerCellIdentifiersForCollectionView(collectionView: UICollectionView?) {
        collectionView?.registerClass(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.IDENTIFIER)
    }
    
    
    
    
    var selections = [PHAsset]()
    var fetchResult: PHFetchResult
    
    
    private let photosManager = PHCachingImageManager.defaultManager()
    private let imageContentMode: PHImageContentMode = .AspectFill

    
    let settings: RHImgPickerSettings?
    var imageSize: CGSize = CGSizeZero
  
    
    
    init(fetchResult: PHFetchResult, selections: PHFetchResult? = nil, settings: RHImgPickerSettings?) {
        self.fetchResult = fetchResult
        self.settings = settings
        
        
        if let selections = selections {
            var selectionsArray = [PHAsset]()
            selections.enumerateObjectsUsingBlock { (asset, idx, stop) -> Void in
                if let asset = asset as? PHAsset {
                    selectionsArray.append(asset)
                }
            }
            self.selections = selectionsArray
        }
        
        
        
        super.init()
    }
    
    
    
    
    //MARK: UICollectionViewDataSource
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return fetchResult.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        UIView.setAnimationsEnabled(false)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCell.IDENTIFIER, forIndexPath: indexPath) as! PhotoCell
        cell.setup()
        
        
        
        // Cancel any pending image requests
        if cell.tag != 0 {
            photosManager.cancelImageRequest(PHImageRequestID(cell.tag))
        }
        
        if let asset = fetchResult[indexPath.row] as? PHAsset {
            cell.asset = asset
            
            

            
            
            // Request image
            cell.tag = Int(photosManager.requestImageForAsset(asset, targetSize: imageSize, contentMode: imageContentMode, options: nil) { (result, _) in
                    cell.imageView.image = result
                })
            
            // Set selection number
            if let asset = fetchResult[indexPath.row] as? PHAsset, let index = selections.indexOf(asset) {
                if let character = settings?.selectionCharacter {
                    
                    cell.selectionString = String(character)
                    
                } else {
                    
                    if  settings?.maxNumberOfSelections == 1 {
                        
                         cell.selectionString = ""
                    }
                    else {
                     cell.selectionString = String(index+1)
                    }
                   
                }
                
                cell.selected = true
            } else {
                cell.selected = false
            }
        }
        
        UIView.setAnimationsEnabled(true)
        
        return cell
    }
    
    
    

    
    
}
