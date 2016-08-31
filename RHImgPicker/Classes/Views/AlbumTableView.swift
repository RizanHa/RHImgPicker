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
//  AlbumTableView.swift
//  Pods
//
//  Created by rizan on 27/08/2016.
//
//




import UIKit
import Photos








class AlbumTableView: UITableView, UITableViewDelegate {

   
    //MARK: - Setup
    
    var albumTableViewDelegate : AlbumTableViewDelegate?
    var albumsDataSource: AlbumTableViewDataSource?
    
    var lastSelectedAlbum : String?
    
    func setup(frame : CGRect, albumsDataSource: AlbumTableViewDataSource) {
    
        
        
        let album = albumsDataSource.fetchResults[0][0] as? PHAssetCollection
        
        lastSelectedAlbum = album?.localizedTitle
        
        AlbumTableViewDataSource.registerCellIdentifiersForTableView(self)
        
        self.frame = frame
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false


        self.allowsSelection = true
        self.allowsMultipleSelection = false
        self.separatorStyle = .None
        
        self.delegate = self
        
        self.dataSource = albumsDataSource
        self.albumsDataSource = albumsDataSource
        

        self.clipsToBounds = false
        
    }
   
    
    
    
    //MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard
            let albumTableViewDelegate = self.albumTableViewDelegate ,
            let albumsDataSource = self.albumsDataSource ,
            let album = albumsDataSource.fetchResults[indexPath.section][indexPath.row] as? PHAssetCollection
            
        else {
            return
        }
        
        
        
        if let lastSelectedAlbum = lastSelectedAlbum , let curentSelectedAlbum = album.localizedTitle {
            
            if lastSelectedAlbum == curentSelectedAlbum {
                albumTableViewDelegate.albumTableViewDidSelectTheSameAlbum()
                return
            }
            
        }
        
        
        // Update photos data source
        albumTableViewDelegate.albumTableViewDidSelect(album)
        self.lastSelectedAlbum = album.localizedTitle
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return AlbumCell.HEIGHT
    }
    
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let albumCell : AlbumCell = cell as? AlbumCell , let animationBlock = self.albumsDataSource?.settings?.albumCellAnimation else { return }
        
        animationBlock(layer: albumCell.layer)
        
    }
    

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
        
    }
    
    
 
    
    
}



//MARK: - AlbumTableViewDelegate protocol

protocol AlbumTableViewDelegate {
    
 
    func albumTableViewDidSelect(album : PHAssetCollection)
    func albumTableViewDidSelectTheSameAlbum()
    
}


