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
//  AlbumTableViewDataSource.swift
//  Pods
//
//  Created by rizan on 27/08/2016.
//
//

import UIKit
import Photos






private let albumDataNotFound : Int = -1    ///

private let previewImg1 : Int = 0
private let previewImg2 : Int = 1
private let previewImg3 : Int = 2


final class AlbumTableViewDataSource : NSObject, UITableViewDataSource {
    
    
    
    class func registerCellIdentifiersForTableView(tableView: UITableView?) {
        tableView?.registerClass(AlbumCell.self, forCellReuseIdentifier: AlbumCell.IDENTIFIER)
    }
    
    
    
    
    private struct AlbumData {
        
        var albumTitle : String?
        var img1 : UIImage?
        var img2 : UIImage?
        var img3 : UIImage?
    }
    
    
    
    let fetchResults: [PHFetchResult]
    
    let settings: RHImgPickerSettings?
    
    private var DATACach : [AlbumData] = []
    
    
    
    func dataCachIndexForAlbum(albumTitle : String?) -> Int  {
    
        var ObjIndex : Int = albumDataNotFound
        var ObjFound : Bool = false
        
        
        for data in DATACach {
            
            ObjIndex = ObjIndex + 1
            if data.albumTitle == albumTitle {
                ObjFound = true
                break
            }
        
        }
        
        if !ObjFound {
            ObjIndex = albumDataNotFound
        }
        
        return ObjIndex
    }
    
    
    func updataDATACach(albumTitle : String?, img : UIImage?, imgIndex : Int) {

        
        if albumTitle == nil {
            return
        }
        
        
        let objIndex = dataCachIndexForAlbum(albumTitle)
        
        if (objIndex != albumDataNotFound  )  {
        
            
            var data = DATACach[objIndex]
            
            DATACach.removeAtIndex(objIndex)
            
            
            switch imgIndex {
            case previewImg1:
                data.img1 = img
                break
                
            case previewImg2:
                data.img2 = img
                break
            
            case previewImg3:
                data.img3 = img
                break
                
                
            default:
                break
            }
            
            DATACach.append(data)
            
            
        
        
        }
        
        
        
        
        

    }
    
    
    
    init(fetchResults: [PHFetchResult], settings: RHImgPickerSettings?) {
        self.fetchResults = fetchResults
        self.settings = settings
        super.init()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchResults.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResults[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        UIView.setAnimationsEnabled(false)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(AlbumCell.IDENTIFIER, forIndexPath: indexPath) as! AlbumCell
        cell.setup()
        
        
        
        
        
        let cachingManager = PHCachingImageManager.defaultManager() as? PHCachingImageManager
        cachingManager?.allowsCachingHighQualityImages = false
        
        
        
        // Fetch album
        if let album = fetchResults[indexPath.section][indexPath.row] as? PHAssetCollection {
            // Title
            cell.albumTitleLabel.text = album.localizedTitle
  
            
            // check for album preview cash DATA
            let objIndex = dataCachIndexForAlbum(album.localizedTitle)
            if (objIndex != albumDataNotFound )  {
                
                let data = DATACach[objIndex]
                
                cell.albumTitleLabel.text = data.albumTitle
                cell.firstImageView.image = data.img1
                cell.secondImageView.image = data.img2
                cell.thirdImageView.image = data.img3
                
                UIView.setAnimationsEnabled(true)
                return cell
                
                
            }

            
            // request Album preview DATA
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [
                NSSortDescriptor(key: "creationDate", ascending: false)
            ]
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.Image.rawValue)
            
            let result = PHAsset.fetchAssetsInAssetCollection(album, options: fetchOptions)
            result.enumerateObjectsUsingBlock { (object, idx, stop) in
                if let asset = object as? PHAsset {
                    let imageSize = CGSize(width: 80, height: 80)
                    let imageContentMode: PHImageContentMode = .AspectFill
                    switch idx {
                    case previewImg1:
                        PHCachingImageManager.defaultManager().requestImageForAsset(asset, targetSize: imageSize, contentMode: imageContentMode, options: nil) { (result, _) in
                            cell.firstImageView.image = result
                            self.updataDATACach(album.localizedTitle, img: cell.firstImageView.image, imgIndex: previewImg1)
                        }
                    case previewImg2:
                        PHCachingImageManager.defaultManager().requestImageForAsset(asset, targetSize: imageSize, contentMode: imageContentMode, options: nil) { (result, _) in
                            cell.secondImageView.image = result
                            self.updataDATACach(album.localizedTitle, img: cell.secondImageView.image, imgIndex: previewImg2)
                        }
                    case previewImg3:
                        PHCachingImageManager.defaultManager().requestImageForAsset(asset, targetSize: imageSize, contentMode: imageContentMode, options: nil) { (result, _) in
                            cell.thirdImageView.image = result
                            self.updataDATACach(album.localizedTitle, img: cell.thirdImageView.image, imgIndex: previewImg3)
                        }
                        
                    default:
                        // Stop enumeration
                        stop.initialize(true)
                    }
                }
            }
        }
        
        
        
        let newData : AlbumData = AlbumData(albumTitle: cell.albumTitleLabel.text, img1: cell.firstImageView.image, img2: cell.secondImageView.image, img3: cell.thirdImageView.image)
        
        self.DATACach.append(newData)
        
        UIView.setAnimationsEnabled(true)
        
        return cell
    }
    
    
    

    
   
    
}

