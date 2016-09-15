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
//  UIViewController+RHImgPicker.swift
//  Pods
//
//  Created by rizan on 27/08/2016.
//
//

import UIKit
import Photos

/**
 Extension on UIViewController to simply presentation of RHImgPicker
 */
public extension UIViewController {
    
    /**
     Present a given image picker.
     - parameter imagePicker: a RHImgPickerViewController to present
     - parameter delegate: a RHImgPickerDelegate protocol or nil
     - parameter animated: To animate the presentation or not
     - parameter completion: presentation completed closure or nil
     */
    
    
    func rh_presentRHImgPickerController(_ imagePicker: RHImgPickerViewController, delegate: RHImgPickerDelegate , animated: Bool, completion: (() -> Void)?) {
        
        RHImgPickerViewController.authorize(fromViewController: self) { (authorized) -> Void in
            // Make sure we are authorized before proceding
            guard authorized == true else { return }
            
            //set delegate
            imagePicker.delegateRImgPicker = delegate
            // Present ViewController
            self.present(imagePicker, animated: animated, completion: completion)
        }
    }
    
    
    
}
