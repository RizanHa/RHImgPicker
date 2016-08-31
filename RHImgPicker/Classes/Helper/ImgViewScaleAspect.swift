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
//  UIImageViewModeScaleAspect.swift
//  Pods
//
//  Created by rizan on 26/08/2016.
//





import UIKit


class ImgViewScaleAspect : UIView {
    
    
    private var newFrameWrapper : CGRect = CGRectZero
    private var newFrameImg : CGRect = CGRectZero
    var img : UIImageView = UIImageView()
    
    
    
    
    //MARK: - Lifecycle
    
    /**
     *  Init self
     *
     *  @return self
     */
    init() {
        
        super.init(frame: CGRectZero)
        self.img.contentMode = .Center
        self.addSubview(self.img)
        self.clipsToBounds = true
        
    }
    
    
    
    /**
     *  Init self with frame
     *
     *  @param frame
     *
     *  @return self
     */
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.img.frame = CGRectMake(0, 0, frame.width, frame.height)
        self.img.contentMode = .Center
        self.addSubview(self.img)
        self.clipsToBounds = true
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.img.contentMode = .Center
        self.frame = self.frame
        self.addSubview(self.img)
        self.clipsToBounds = true
        
    }
    
    
    
    //MARK: - Automatic Animate
    
    /**
     *  Automatic Animate Fill to Fit
     *
     *  @param frame
     *  @param duration
     *  @param delay
     */
    func animateToScaleAspectFitToFrame(frame: CGRect,  duration : Double,  delay : Double ) {
        
        if (!self.UIImageIsEmpty()) {
            self.initToScaleAspectFitToFrame(frame)
            
            UIView.animateWithDuration(duration, delay: delay, options: .AllowUserInteraction , animations: {
                self.animaticToScaleAspectFit()
                }, completion: { (finish) in
                    // finish animation
            })
            
        }else{
            print("ERROR, UIImageView %@ don't have UIImage",self);
        }
        
        
    }
    
    /**
     *  Automatic Animate Fit to Fill
     *
     *  @param frame
     *  @param duration
     *  @param delay
     */
    func animateToScaleAspectFillToFrame (frame : CGRect, duration:Double,  delay : Double ) {
        
        if (!self.UIImageIsEmpty()) {
            
            self.initToScaleAspectFillToFrame(frame)
            
            UIView.animateWithDuration(duration, delay: delay, options: .AllowUserInteraction , animations: {
                self.animaticToScaleAspectFill()
                }, completion: { (finish) in
                    // finish animation
                    self.animateFinishToScaleAspectFill()
            })
            
        }else{
            print("ERROR, UIImageView %@ don't have UIImage",self)
        }
        
    }
    
    /**
     *  Automatic Animate Fill to Fit with completion
     *
     *  @param frame
     *  @param duration
     *  @param delay
     *  @param completion
     */
    func animateToScaleAspectFitToFrame (frame:CGRect,  duration:Double,  delay:Double,  completion:(finish: Bool) -> Void) {
        
        if (!self.UIImageIsEmpty()) {
            self.initToScaleAspectFitToFrame(frame)
            
            
            UIView.animateWithDuration(duration, delay: delay, options: .AllowUserInteraction , animations: {
                self.animaticToScaleAspectFit()
                }, completion: { (finish) in
                    // finish animation
                    completion(finish: finish)
            })
            
        }else{
            ///if (completion != nil) {
            completion(finish:true)
            ///}
            print("ERROR, UIImageView %@ don't have UIImage",self)
        }
        
        
    }
    
    /**
     *  Automatic Animate Fit to Fill with completion
     *
     *  @param frame
     *  @param duration
     *  @param delay
     *  @param completion
     */
    func animateToScaleAspectFillToFrame(frame :CGRect,  duration:Double ,delay: Double, completion:(finish:Bool) -> Void) {
        
        if (!self.UIImageIsEmpty()) {
            self.initToScaleAspectFillToFrame(frame)
            
            UIView.animateWithDuration(duration, delay: delay, options: .AllowUserInteraction , animations: {
                self.animaticToScaleAspectFill()
                }, completion: { (finish) in
                    // finish animation
                    self.animateFinishToScaleAspectFill()
                    completion(finish: finish)
            })
            
        }else{
            ///if (completion) {
            completion(finish: true);
            ///}
            print("ERROR, UIImageView %@ don't have UIImage",self)
        }
        
    }
    
    //MARK: - Manual Animate
    
    /**
     *  Init Manual Function Fit
     *
     *  @param newFrame
     */
    func initToScaleAspectFitToFrame(newFrame : CGRect ) {
        
        if (!self.UIImageIsEmpty()) {
            
            let ratioImg = (img.image!.size.width) / (img.image!.size.height);
            
            if ( self.choiseFunctionWithRationImg(ratioImg ,newFrame:self.frame)) {
                self.img.frame = CGRectMake( -(self.frame.size.height * ratioImg - self.frame.size.width) / 2.0, 0,
                                             self.frame.size.height * ratioImg, self.frame.size.height)
            }else{
                self.img.frame = CGRectMake(0, -(self.frame.size.width / ratioImg - self.frame.size.height) / 2.0,
                                            self.frame.size.width, self.frame.size.width / ratioImg)
            }
        }else{
            print("ERROR, UIImageView %@ don't have UIImage",self)
        }
        
        img.contentMode = .ScaleAspectFit
        
        self.newFrameImg = CGRectMake(0, 0, newFrame.size.width, newFrame.size.height)
        self.newFrameWrapper = newFrame
        
    }
    
    /**
     *  Init Manual Function Fill
     *
     *  @param newFrame
     */
    func initToScaleAspectFillToFrame (newFrame : CGRect) {
        
        if (!self.UIImageIsEmpty()) {
            
            let ratioImg = ( img.image!.size.width) / ( img.image!.size.height)
            
            if ( self.choiseFunctionWithRationImg(ratioImg, newFrame:newFrame)) {
                self.newFrameImg = CGRectMake( -(newFrame.size.height * ratioImg - newFrame.size.width) / 2.0, 0,
                                               newFrame.size.height * ratioImg, newFrame.size.height)
                
            }else{
                self.newFrameImg = CGRectMake(0, -(newFrame.size.width / ratioImg - newFrame.size.height) / 2.0, newFrame.size.width,
                                              newFrame.size.width / ratioImg)
            }
        }else{
            print("ERROR, UIImageView %@ don't have UIImage",self)
        }
        
        self.newFrameWrapper = newFrame;
        
    }
    
    //MARK:  - Animatic Function
    
    /**
     *  Animatic Fucntion Fit
     */
    func animaticToScaleAspectFit() {
        
        self.img.frame =  newFrameImg
        self.frame = newFrameWrapper
        
    }
    
    /**
     *  Animatic Function Fill
     */
    func animaticToScaleAspectFill() {
        
        self.img.frame = newFrameImg
        self.frame = newFrameWrapper
        
    }
    
    //MARK: - - Last Function
    
    /**
     *  Last Function Fit
     */
    func animateFinishToScaleAspectFit() {
        
        //
        // Fake function
        //
        
    }
    
    /**
     *  Last Function Fill
     */
    func animateFinishToScaleAspectFill() {
        self.img.contentMode = .ScaleAspectFill
        self.img.frame  = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        
    }
    

    
    //MARK: - Private
    
    private func UIImageIsEmpty() -> Bool {
        
      
        guard
            let image : UIImage = img.image
            else { return true }
        
        
       if (image.size.height == 0 || image.size.width == 0)  {
            return true
        }

        
        return false
        
        
    }
    
    
    
    
    
    private func choiseFunctionWithRationImg(ratioImg : CGFloat , newFrame : CGRect ) -> Bool {
        
        var resultat = false
        
        let ratioSelf = (newFrame.size.width) / (newFrame.size.height)
        
        if (ratioImg < 1) {
            if (ratioImg > ratioSelf ) {resultat = true }
        }else{
            if (ratioImg > ratioSelf ) { resultat = true }
        }
        
        return resultat
        
    }
    
    
}
 
 