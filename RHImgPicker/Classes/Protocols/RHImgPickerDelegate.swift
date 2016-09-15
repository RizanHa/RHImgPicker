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
//  RHImgPickerDelegate.swift
//  Pods
//
//  Created by rizan on 26/08/2016.
//
//

import Foundation
import Photos


/**
 
 
 Note that this protocol tells the delegate synchronously.
 */
public protocol RHImgPickerDelegate {
    
    
    
    /**
        Tells the delegate that the selection process is Finish and provides the selected images in the pick order.
     */
    func RHImgPickerDidFinishPickingAssets(_ assets: [PHAsset])
    
    
    /**
     Tells the delegate that RHImgPicker did clear all selection (did removed all selected images from the selection)
     */
    func RHImgPickerDidClearAllSelectedAssets()
    
    
    /**
     Tells the delegate that an Asset did selected and provides the selected asset.
     */
    func RHImgPickerDidSelectAsset(_ asset: PHAsset)
    
    
    /**
     Tells the delegate that an Asset did deselected and provides the deselected asset.
     */
    func RHImgPickerDidDeselectAsset(_ asset: PHAsset)
    
    
    
    
}

