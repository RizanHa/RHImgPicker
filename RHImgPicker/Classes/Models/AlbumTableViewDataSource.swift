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



fileprivate enum AlbumPreviewImageIndex : Int {
    case imgNotFound = -1
    case img1 = 0
    case img2 = 1
    case img3 = 2
    
}


final class AlbumTableViewDataSource : NSObject, UITableViewDataSource {
    
    
    
    class func registerCellIdentifiersForTableView(_ tableView: UITableView?) {
        tableView?.register(AlbumCell.self, forCellReuseIdentifier: AlbumCell.IDENTIFIER)
    }
    
    

    
    fileprivate struct AlbumData {
        
        var albumTitle : String?
        var img1 : UIImage?
        var img2 : UIImage?
        var img3 : UIImage?
    }
    
    
    
    let fetchResults: [PHFetchResult<AnyObject>]
    
    let settings: RHImgPickerSettings?
    
    fileprivate var DATACach : [AlbumData] = []
    
    
    
    fileprivate func dataCachIndexForAlbum(_ albumTitle : String?) -> AlbumPreviewImageIndex  {
    
        var ObjIndex : AlbumPreviewImageIndex = .imgNotFound
        
        for (idx,data) in DATACach.enumerated() {
            
            if data.albumTitle == albumTitle {
                
                let index = min(idx, AlbumPreviewImageIndex.img3.rawValue)
                
                if let oj = AlbumPreviewImageIndex(rawValue: idx) {
                    ObjIndex = oj
                }
                
                break
            }
        
        }
        
        return ObjIndex
    }
    
    
    
    fileprivate func updataDATACach(_ albumTitle : String?, img : UIImage?, imgIndex : AlbumPreviewImageIndex) {

        
        if albumTitle == nil {
            return
        }
        
        
        let objIndex = dataCachIndexForAlbum(albumTitle)
        
        if (objIndex != .imgNotFound  )  {
        
            var data = DATACach[objIndex.rawValue]
            DATACach.remove(at: objIndex.rawValue)
            
            
            switch imgIndex {
            case .img1:
                data.img1 = img
                break
                
            case .img2:
                data.img2 = img
                break
            
            case .img3:
                data.img3 = img
                break
                
                
            default:
                break
            }
            
            DATACach.append(data)
        }
    }
    
    
    
    init(fetchResults: [PHFetchResult<AnyObject>], settings: RHImgPickerSettings?) {
        self.fetchResults = fetchResults
        self.settings = settings
        super.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResults.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResults[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        UIView.setAnimationsEnabled(false)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumCell.IDENTIFIER, for: indexPath) as! AlbumCell
        cell.layoutCell()
        
        
        
        
        
        let cachingManager = PHCachingImageManager.default() as? PHCachingImageManager
        cachingManager?.allowsCachingHighQualityImages = false
        
        
        
        // Fetch album
        if let album = fetchResults[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row] as? PHAssetCollection {
            // Title
            cell.albumTitleLabel.text = album.localizedTitle
  
            
            // check for album preview cash DATA
            let objIndex = dataCachIndexForAlbum(album.localizedTitle)
            if (objIndex != .imgNotFound )  {
                
                let data = DATACach[objIndex.rawValue]
                
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
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            
            let result = PHAsset.fetchAssets(in: album, options: fetchOptions)
            result.enumerateObjects( { (object, idx, stop) in
                if let asset = object as? PHAsset {
                    let imageSize = CGSize(width: 80, height: 80)
                    let imageContentMode: PHImageContentMode = .aspectFill
                    
                    switch idx {
                    case AlbumPreviewImageIndex.img1.rawValue:
                        PHCachingImageManager.default().requestImage(for: asset, targetSize: imageSize, contentMode: imageContentMode, options: nil) { (result, _) in
                            cell.firstImageView.image = result
                            self.updataDATACach(album.localizedTitle, img: cell.firstImageView.image, imgIndex: .img1)
                        }
                    case AlbumPreviewImageIndex.img2.rawValue:
                        PHCachingImageManager.default().requestImage(for: asset, targetSize: imageSize, contentMode: imageContentMode, options: nil) { (result, _) in
                            cell.secondImageView.image = result
                            self.updataDATACach(album.localizedTitle, img: cell.secondImageView.image, imgIndex: .img2)
                        }
                    case AlbumPreviewImageIndex.img3.rawValue:
                        PHCachingImageManager.default().requestImage(for: asset, targetSize: imageSize, contentMode: imageContentMode, options: nil) { (result, _) in
                            cell.thirdImageView.image = result
                            self.updataDATACach(album.localizedTitle, img: cell.thirdImageView.image, imgIndex: .img3)
                        }
                        
                    default:
                        // Stop enumeration
                        stop.initialize(to: true)
                    }
                }
            })
        }
        
        
        
        let newData : AlbumData = AlbumData(albumTitle: cell.albumTitleLabel.text, img1: cell.firstImageView.image, img2: cell.secondImageView.image, img3: cell.thirdImageView.image)
        
        self.DATACach.append(newData)
        
        UIView.setAnimationsEnabled(true)
        
        return cell
    }
    
    
    

    
   
    
}

