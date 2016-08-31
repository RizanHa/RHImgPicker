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
//  PreviewViewController.swift
//  Pods
//
//  Created by rizan on 28/08/2016.
//
//


import UIKit

final class PreviewViewController : UIViewController, UIGestureRecognizerDelegate {
    var imageView: UIImageView?

    private var background = false
    var backgroundColor : UIColor = UIColor.blackColor()
    
    var backgroundImageView : UIImageView?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.view.backgroundColor = UIColor.clearColor()
        
        backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView?.contentMode = .ScaleAspectFit
        backgroundImageView?.backgroundColor = UIColor.clearColor()
        backgroundImageView?.blurImage(.Dark)
        backgroundImageView?.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.view.addSubview(backgroundImageView!)
        
        
        
        imageView = UIImageView(frame: view.bounds)
        imageView?.contentMode = .ScaleAspectFit
        imageView?.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.addSubview(imageView!)

        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.addTarget(self, action: #selector(PreviewViewController.toggleBackground))
        view.addGestureRecognizer(tapRecognizer)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        super.loadView()
    }
    
    

    func popToRootController() {
    
        self.navigationController?.popToRootViewControllerAnimated(true)
    
    }
    
    
    func toggleBackground() {
        background = !background
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.toggleBackgroundColor()
        })
    }
    

    
 
    
    func toggleBackgroundColor() {
       
        
        
        guard let imageView = self.imageView else {
            return
        }

        let aColor: UIColor

        if self.background {
            aColor = UIColor.blackColor()
        } else {
            aColor = UIColor.clearColor()
        }
        
        imageView.backgroundColor = aColor
        
        
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        
        // hide nav bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        let settings = RHSettings.sharedInstance
        self.backgroundImageView?.frame = self.view.bounds
        self.imageView?.frame = self.view.bounds
        self.imageView?.backgroundColor = UIColor.clearColor()
        offsetPoint = CGPointZero
        
        
    }
    
    
    private var offsetPoint : CGPoint = CGPointZero
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first {
            let currentPoint = touch.locationInView(self.view)
           
            
            if offsetPoint == CGPointZero {
                
                
                offsetPoint = CGPointMake((self.imageView?.center.x)! -  currentPoint.x,  (self.imageView?.center.y)! - currentPoint.y )
                background = false
                self.imageView?.backgroundColor = UIColor.clearColor()
                
            }
            else {
            
                
                self.imageView?.center = CGPointMake(currentPoint.x + offsetPoint.x, currentPoint.y + offsetPoint.y)
            
            }
            
            
            
        }
        
    }
    
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first {
            let currentPoint = touch.locationInView(self.view)
            
     
            if (offsetPoint == CGPointZero || imgViewIsInMid() ) {
            
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                     self.imageView?.center = self.view.center
                })
                
            }
            else {
                
                popToRootController()
            }
            
            offsetPoint = CGPointZero
            
        }
        
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
        
        self.imageView?.center = self.view.center
        offsetPoint = CGPointZero
        
        
    }
    
    
    
    
    private func imgViewIsInMid() -> Bool {
        guard let imageView = self.imageView else {
            return false
        }
        
        let maxOffset : CGFloat = 80
        
        let centerX = self.view.center.x
        let centerY = self.view.center.y
        
        let maxX = imageView.center.x + maxOffset
        let minX = imageView.center.x - maxOffset
        let maxY = imageView.center.y + maxOffset
        let minY = imageView.center.y - maxOffset
      
        
        if ( centerX < maxX && centerX > minX ) {
            if ( centerY < maxY && centerY > minY ) {
                return true
            }
        }
        
        
        return false
    }
    
    
}







