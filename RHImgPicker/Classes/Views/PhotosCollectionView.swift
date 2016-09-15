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
        super.init(frame: CGRect.zero, collectionViewLayout:  RHCollectionGridViewLayout())
    }

    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ///fatalError("init(coder:) has not been implemented")
    }

    
    func setup(_ frame : CGRect) {
    
        self.frame = frame
        self.allowsMultipleSelection = true
        self.delegate = self
        
        self.bounces = true
        self.isScrollEnabled = true
        self.scrollsToTop = true
        self.alwaysBounceVertical = true

        
        // Register cells
        PhotoCollectionViewDataSource.registerCellIdentifiersForCollectionView(self)
        
    
    }
    
    
    
    
    //Mark: - sync collection
    
    fileprivate func synchronizeSelectionInCollectionView(_ collectionView: UICollectionView) {
        guard let photosDataSource = self.photosDataSource else {
            return
        }
        
        // Get indexes of the selected assets
        let mutableIndexSet = NSMutableIndexSet()
        for object in photosDataSource.selections {
            let index = photosDataSource.fetchResult.index(of: object)
            if index != NSNotFound {
                mutableIndexSet.add(index)
                
            }
        }
        
        // Convert into index paths
        let indexPaths = mutableIndexSet.rh_indexPathsForSection(0)
        
        
        
        // Loop through them and set them as selected in the collection view
        for indexPath in indexPaths {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
        }
        

        
    }
    

    
    func synchronizeCollectionView() {

        
        // Reload and sync selections
        self.reloadData()
        self.synchronizeSelectionInCollectionView(self)
        
        
    }
    
    
    func clearSelectdCells() {
        self.deselectVisableCellsFromCollectionViewAnimated(true)
        self.deselectAllCellsAnimated(false)
    
    }

  
    fileprivate func deselectVisableCellsFromCollectionViewAnimated(_ animated : Bool) {
    
        // update cell selection String
        let cells = self.visibleCells
        
        
        UIView.animate(withDuration: 0.15, animations: { 
            
            for cell in  cells {
                if let photoCell = cell as? PhotoCell {
                    if photoCell.isSelected {
                        self.deselectItem(at: self.indexPath(for: photoCell)!, animated: animated)
                        photoCell.selectionString = ""
                    }
                    else {
                         photoCell.selectionString = ""
                    }
                }
            }

        }) 
        
        
        
        
        
    }
    
    fileprivate func deselectAllCellsAnimated(_ animated : Bool) {
        guard let photosDataSource = self.photosDataSource else {
            return
        }
        
        
        
        // Get indexes of the selected assets
        let mutableIndexSet = NSMutableIndexSet()
        for object in photosDataSource.selections {
            let index = photosDataSource.fetchResult.index(of: object)
            if index != NSNotFound {
                mutableIndexSet.add(index)
            }
        }
        
        // Convert into index paths
        let indexPaths = mutableIndexSet.rh_indexPathsForSection(0)
        
        
        // Loop through them and set them as selected in the collection view
        for indexPath in indexPaths {
            self.deselectItem(at: indexPath, animated: animated)
        }
        
        
    
    }
    
    
    //MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let photosDataSource = self.photosDataSource, let settings = photosDataSource.settings else {
            return false
        }
        
        
        
        if (collectionView.isUserInteractionEnabled && photosDataSource.selections.count < settings.maxNumberOfSelections) {
            
            
            
            return true
        } else if (collectionView.isUserInteractionEnabled && settings.maxNumberOfSelections == 1 && photosDataSource.selections.count == 1) {
            
            self.deselectVisableCellsFromCollectionViewAnimated(true)
            self.deselectAllCellsAnimated(false)
            photosDataSource.selections.removeAll()
            
         
            
            
            return true
        } else {
            return false
        }
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photosDataSource = self.photosDataSource  , let settings = photosDataSource.settings , let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell, let asset = photosDataSource.fetchResult.object(at: (indexPath as NSIndexPath).row) as? PHAsset else {
            return
        }
        
        
        // Select asset if not already selected
        if !photosDataSource.selections.contains(asset) {
            photosDataSource.selections.append(asset)
        }
        
        
        // delegate call (Synchronous)
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
    
    
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let photosDataSource = self.photosDataSource  , let asset = photosDataSource.fetchResult.object(at: (indexPath as NSIndexPath).row) as? PHAsset, let index = photosDataSource.selections.index(of: asset) , let photocell = collectionView.cellForItem(at: indexPath) as? PhotoCell  else {
            return
        }
        
        // Deselect asset
        photosDataSource.selections.remove(at: index)
        
        
        
        // delegate call (Synchronous)
        if let photosCollectionViewDelegate = self.photosCollectionViewDelegate {
        
            photosCollectionViewDelegate.photosCollectionViewDelegateDidDeselect(asset)
        
        }
        
        
        
        // update visible cell selection String if no selectionCharacter define
        if RHSettings.sharedInstance.selectionCharacter == nil {
            if let curentDeselectedItemIndex : Int = Int(photocell.selectionString) {
                
                let maxSelections = photosDataSource.selections.count
                
                if curentDeselectedItemIndex <= maxSelections  {
                    
                    let cells = collectionView.visibleCells
                    
                    for cell in  cells {
                        
                        if let photoCell = cell as? PhotoCell {
                            
                            if photoCell.isSelected {
                                
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
        
        }
        
        
       
        
    }
    
    
    // MARK: - scrollView

    //collection view schuld scroll to top on statusBar tap
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    
    
    
    // MARK: - Traits
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let photosDataSource = self.photosDataSource  , let settings = photosDataSource.settings else {
            return
        }
        
        super.traitCollectionDidChange(previousTraitCollection)
        
        if let collectionViewFlowLayout = collectionViewLayout as? RHCollectionGridViewLayout {
            
            // set image size on collection view
            let itemSpacing: CGFloat = 2.0
            let cellsPerRow = settings.cellsPerRow(traitCollection.verticalSizeClass, traitCollection.horizontalSizeClass)
            collectionViewFlowLayout.itemSpacing = itemSpacing
            collectionViewFlowLayout.itemsPerRow = cellsPerRow
            photosDataSource.imageSize = collectionViewFlowLayout.itemSize
            
            
        }

        
    }
    
}



//MARK: - PhotosCollectionViewDelegate protocol

protocol PhotosCollectionViewDelegate {
    
    func photosCollectionViewDelegateDidSelect(_ asset : PHAsset)
    func photosCollectionViewDelegateDidDeselect(_ asset : PHAsset)
    
}


