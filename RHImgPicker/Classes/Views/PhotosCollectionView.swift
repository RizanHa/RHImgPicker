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
//  PhotosCollectionView.swift
//  Pods
//
//  Created by rizan on 28/08/2016.
//
//

import UIKit
import Photos





class PhotosCollectionView: UICollectionView, UICollectionViewDelegate {

    
    //MARK: - Setup
    var photosCollectionViewDelegate : PhotosCollectionViewDelegate?
    var photosDataSource: PhotoCollectionViewDataSource?
    
    init() {
        super.init(frame: CGRectZero, collectionViewLayout:  RHCollectionGridViewLayout())
    }

    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ///fatalError("init(coder:) has not been implemented")
    }

    
    func setup(frame : CGRect) {
    
        self.frame = frame
        self.allowsMultipleSelection = true
        self.delegate = self
        
        self.bounces = true
        self.scrollEnabled = true
        self.scrollsToTop = true
        self.alwaysBounceVertical = true

        
        // Register cells
        PhotoCollectionViewDataSource.registerCellIdentifiersForCollectionView(self)
        
    
    }
    
    
    
    
    //Mark: - sync collection
    
    private func synchronizeSelectionInCollectionView(collectionView: UICollectionView) {
        guard let photosDataSource = self.photosDataSource else {
            return
        }
        
        // Get indexes of the selected assets
        let mutableIndexSet = NSMutableIndexSet()
        for object in photosDataSource.selections {
            let index = photosDataSource.fetchResult.indexOfObject(object)
            if index != NSNotFound {
                mutableIndexSet.addIndex(index)
            }
        }
        
        // Convert into index paths
        let indexPaths = mutableIndexSet.rh_indexPathsForSection(0)
        
        
        
        // Loop through them and set them as selected in the collection view
        for indexPath in indexPaths {
            collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        }
        

        
    }
    

    
    func synchronizeCollectionView() {

        UIView.setAnimationsEnabled(false)
        
        let collectionView = self
        
        // Reload and sync selections
        collectionView.reloadData()
        
        synchronizeSelectionInCollectionView(collectionView)
        
        UIView.setAnimationsEnabled(true)
        
    }

  
    func deselectVisableCellsFromCollectionViewAnimated(animated : Bool) {
    
        // update cell selection String
        let cells = self.visibleCells()
        
        
        UIView.animateWithDuration(0.15) { 
            
            for cell in  cells {
                if let photoCell = cell as? PhotoCell {
                    if photoCell.selected {
                        self.deselectItemAtIndexPath(self.indexPathForCell(photoCell)!, animated: animated)
                        photoCell.selectionString = ""
                    }
                    else {
                         photoCell.selectionString = ""
                    }
                }
            }

        }
        
        
        
        
        
    }
    
    func deselectAllCellsAnimated(animated : Bool) {
        guard let photosDataSource = self.photosDataSource else {
            return
        }
        
        // Get indexes of the selected assets
        let mutableIndexSet = NSMutableIndexSet()
        for object in photosDataSource.selections {
            let index = photosDataSource.fetchResult.indexOfObject(object)
            if index != NSNotFound {
                mutableIndexSet.addIndex(index)
            }
        }
        
        // Convert into index paths
        let indexPaths = mutableIndexSet.rh_indexPathsForSection(0)
        
        // Loop through them and set them as selected in the collection view
        for indexPath in indexPaths {
            self.deselectItemAtIndexPath(indexPath, animated: animated)
        }
        
        
    
    }
    
    
    //MARK: - UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        guard let photosDataSource = self.photosDataSource, let settings = photosDataSource.settings else {
            return false
        }
        
       
        
        if (collectionView.userInteractionEnabled && photosDataSource.selections.count < settings.maxNumberOfSelections) {
            return true
        } else if (collectionView.userInteractionEnabled && settings.maxNumberOfSelections == 1 && photosDataSource.selections.count == 1) {
            
            deselectVisableCellsFromCollectionViewAnimated(true)
            deselectAllCellsAnimated(false)
            photosDataSource.selections.removeAll()
            
            return true
        } else {
            return false
        }
        
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let photosDataSource = self.photosDataSource  , let settings = photosDataSource.settings , let cell = collectionView.cellForItemAtIndexPath(indexPath) as? PhotoCell, let asset = photosDataSource.fetchResult.objectAtIndex(indexPath.row) as? PHAsset else {
            return
        }
        
        
        // Select asset if not already selected
        photosDataSource.selections.append(asset)
        
        
        if let photosCollectionViewDelegate = self.photosCollectionViewDelegate {
            photosCollectionViewDelegate.photosCollectionViewDelegateDidSelect(asset)
        }
        
        
        // Set selection number
        if let selectionCharacter = settings.selectionCharacter {
            cell.selectionString = String(selectionCharacter)
        } else {
            cell.selectionString = String(photosDataSource.selections.count)
        }
        
        
    }
    
    
    func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
        
    }
    
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        guard let photosDataSource = self.photosDataSource  , let asset = photosDataSource.fetchResult.objectAtIndex(indexPath.row) as? PHAsset, let index = photosDataSource.selections.indexOf(asset) , let photocell = collectionView.cellForItemAtIndexPath(indexPath) as? PhotoCell  else {
            return
        }
        
        // Deselect asset
        photosDataSource.selections.removeAtIndex(index)
        
        
        if let photosCollectionViewDelegate = self.photosCollectionViewDelegate {
        
            photosCollectionViewDelegate.photosCollectionViewDelegateDidDeselect(asset)
        
        }
        
        
        
        // update cell selection String
        if let curentDeselectedItemIndex : Int = Int(photocell.selectionString) {
            
            let maxSelections = photosDataSource.selections.count

            if curentDeselectedItemIndex <= maxSelections  {
                
                let cells = collectionView.visibleCells()
                
                for cell in  cells {
                    
                    if let photoCell = cell as? PhotoCell {
                        
                        if photoCell.selected {
                            
                            if let cellStringAsInt = Int(photoCell.selectionString) {
                                
                                if cellStringAsInt > curentDeselectedItemIndex {
                                    
                                    photoCell.updata(max(0, cellStringAsInt-1))
                                }
                                
                            }
                            
                        }
                        
                    }
                }
            }
        }
        
        
        // Reload selected cells to update their selection number
        UIView.setAnimationsEnabled(false)
        synchronizeSelectionInCollectionView(collectionView)
        UIView.setAnimationsEnabled(true)
        
        
    }
    
    
    // MARK: - scrollView

    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        return true
    }
    
    
    
    
    // MARK: - Traits
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        guard let photosDataSource = self.photosDataSource  , let settings = photosDataSource.settings else {
            return
        }
        
        super.traitCollectionDidChange(previousTraitCollection)
        
        if let collectionViewFlowLayout = collectionViewLayout as? RHCollectionGridViewLayout {
            let itemSpacing: CGFloat = 2.0
            let cellsPerRow = settings.cellsPerRow(verticalSize: traitCollection.verticalSizeClass, horizontalSize: traitCollection.horizontalSizeClass)
            
            collectionViewFlowLayout.itemSpacing = itemSpacing
            collectionViewFlowLayout.itemsPerRow = cellsPerRow
            
            photosDataSource.imageSize = collectionViewFlowLayout.itemSize
            
            
        }

        
    }
    
}



//MARK: - PhotosCollectionViewDelegate protocol

protocol PhotosCollectionViewDelegate {
    
    func photosCollectionViewDelegateDidSelect(asset : PHAsset)
    func photosCollectionViewDelegateDidDeselect(asset : PHAsset)
    
}


