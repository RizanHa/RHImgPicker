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

    fileprivate var background = false
    var backgroundColor : UIColor = UIColor.black
    
    var backgroundImageView : UIImageView?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.view.backgroundColor = UIColor.clear
        
        backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView?.contentMode = .scaleAspectFit
        backgroundImageView?.backgroundColor = UIColor.clear
        backgroundImageView?.blurImage(.dark)
        backgroundImageView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(backgroundImageView!)
        
        
        
        imageView = UIImageView(frame: view.bounds)
        imageView?.contentMode = .scaleAspectFit
        imageView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
    
        self.navigationController?.popToRootViewController(animated: true)
    
    }
    
    
    func toggleBackground() {
        background = !background
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.toggleBackgroundColor()
        })
    }
    

    
 
    
    func toggleBackgroundColor() {
       
        
        
        guard let imageView = self.imageView else {
            return
        }

        let aColor: UIColor

        if self.background {
            aColor = UIColor.black
        } else {
            aColor = UIColor.clear
        }
        
        imageView.backgroundColor = aColor
        
        
        
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        // hide nav bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.backgroundImageView?.frame = self.view.bounds
        self.imageView?.frame = self.view.bounds
        self.imageView?.backgroundColor = UIColor.clear
        offsetPoint = CGPoint.zero
        
        
    }
    
    
    fileprivate var offsetPoint : CGPoint = CGPoint.zero
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
           
            
            if offsetPoint == CGPoint.zero {
                
                
                offsetPoint = CGPoint(x: (self.imageView?.center.x)! -  currentPoint.x,  y: (self.imageView?.center.y)! - currentPoint.y )
                background = false
                self.imageView?.backgroundColor = UIColor.clear
                
            }
            else {
            
                
                self.imageView?.center = CGPoint(x: currentPoint.x + offsetPoint.x, y: currentPoint.y + offsetPoint.y)
            
            }
            
            
            
        }
        
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if (offsetPoint == CGPoint.zero || imgViewIsInMid() ) {
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.imageView?.center = self.view.center
            })
            
        }
        else {
            
            popToRootController()
        }
        
        offsetPoint = CGPoint.zero
        
        
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        self.imageView?.center = self.view.center
        offsetPoint = CGPoint.zero
        
        
    }
    
    
    
    
    fileprivate func imgViewIsInMid() -> Bool {
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







