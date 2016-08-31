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
//  PhotoCell.swift
//  Pods
//
//  Created by rizan on 26/08/2016.
//
//

import UIKit
import Photos



/**
 The photo cell.
 */
class PhotoCell: UICollectionViewCell {
    
    class var IDENTIFIER: String {
        
        return "PhotoCell_IDENTIFIER"
    }

    
    
    
    
    
    //MARK: - Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ////fatalError("init(coder:) has not been implemented")
    }

    
    var imageView: UIImageView = UIImageView()
    var selectionOverlayView: UIView = UIView()
    var selectionView: SelectionView = SelectionView()
    
    
    private var cellDidLoad : Bool = false
    
    func setup() {
    
        
        let frame : CGRect = self.frame
        
        let sizeSelectionViewXY = self.frame.size.height*0.35
        imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        selectionOverlayView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        selectionView.frame = CGRectMake(frame.size.width -  sizeSelectionViewXY*1.15, frame.size.height - sizeSelectionViewXY*1.15 ,sizeSelectionViewXY ,sizeSelectionViewXY )
     
        
        
        
        if cellDidLoad {
            return
        }
        cellDidLoad = true
        
        
       
        
        
        imageView.contentMode = .ScaleAspectFill
   
        selectionView.backgroundColor = UIColor.clearColor()
        
        selectionOverlayView.backgroundColor = RHSettings.sharedInstance.selectionHighlightColor
        self.selectionOverlayView.alpha = 0.0
        
        
        imageView.clipsToBounds = true
        selectionOverlayView.clipsToBounds = true
        selectionView.clipsToBounds = true
        self.clipsToBounds = true
        
        
        self.addSubview(imageView)
        self.addSubview(selectionOverlayView)
        self.addSubview(selectionView)
        
    }
    
    
    
    
    
    //MARK: -
    
    
    func updata(index : Int) {
    
        self.selectionString = String(index)
        
    }
    
    
    
    weak var asset: PHAsset?

    var selectionString: String {
        get {
            return selectionView.selectionString
        }
        
        set {
            selectionView.selectionString = newValue
        }
    }
    
    override var selected: Bool {
        get {
            return super.selected
        }
        
        set {
            let hasChanged = selected != newValue
            super.selected = newValue
            
            if UIView.areAnimationsEnabled() && hasChanged {
                UIView.animateWithDuration(NSTimeInterval(0.1), animations: { () -> Void in
                    // Set alpha for views
                    self.updateAlpha(newValue)
                    
                    // Scale all views down a little
                    self.transform = CGAffineTransformMakeScale(0.95, 0.95)
                }) { (finished: Bool) -> Void in
                    UIView.animateWithDuration(NSTimeInterval(0.1), animations: { () -> Void in
                        // And then scale them back upp again to give a bounce effect
                        self.transform = CGAffineTransformMakeScale(1.0, 1.0)
                        }, completion: nil)
                }
            } else {
                updateAlpha(newValue)
            }
        }
    }
    
    private func updateAlpha(selected: Bool) {
        if selected == true {
            self.selectionView.alpha = 1.0
            self.selectionOverlayView.alpha = 0.3
        } else {
            self.selectionView.alpha = 0.0
            self.selectionOverlayView.alpha = 0.0
        }
    }

    
    
}






/**
 Used as an overlay on selected cells
 */
@IBDesignable final class SelectionView: UIView {
    
    
    
    //MARK: - SelectionView
    
    
    var selectionString: String = "" {
        didSet {
            if selectionString != oldValue {
                setNeedsDisplay()
            }
        }
    }
    
    
    override func drawRect(rect: CGRect) {
        
        let settings: RHImgPickerSettings = RHSettings.sharedInstance
        
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Color Declarations
        
        //// Shadow Declarations
        let shadow2Offset = CGSize(width: 0.1, height: -0.1);
        let shadow2BlurRadius: CGFloat = 2.5;
        
        //// Frames
        let checkmarkFrame = bounds;
        
        //// Subframes
        let group = CGRect(x: CGRectGetMinX(checkmarkFrame) + 3, y: CGRectGetMinY(checkmarkFrame) + 3, width: CGRectGetWidth(checkmarkFrame) - 6, height: CGRectGetHeight(checkmarkFrame) - 6)
        
        //// CheckedOval Drawing
        let checkedOvalPath = UIBezierPath(ovalInRect: CGRectMake(CGRectGetMinX(group) + floor(CGRectGetWidth(group) * 0.0 + 0.5), CGRectGetMinY(group) + floor(CGRectGetHeight(group) * 0.0 + 0.5), floor(CGRectGetWidth(group) * 1.0 + 0.5) - floor(CGRectGetWidth(group) * 0.0 + 0.5), floor(CGRectGetHeight(group) * 1.0 + 0.5) - floor(CGRectGetHeight(group) * 0.0 + 0.5)))
        CGContextSaveGState(context)
        CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, settings.selectionShadowColor.CGColor)
        settings.selectionFillColor.setFill()
        checkedOvalPath.fill()
        CGContextRestoreGState(context)
        
        settings.selectionStrokeColor.setStroke()
        checkedOvalPath.lineWidth = 1
        checkedOvalPath.stroke()
        
        
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        
        //// Check mark for single assets
        if (settings.maxNumberOfSelections == 1) {
            CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
            
            let pixelSize = rect.size.height / 8
            let offsetX = pixelSize*1.5
            let offsetY = pixelSize*1.0
            
            
            let checkPath = UIBezierPath()
            checkPath.moveToPoint(CGPoint(x: offsetX + 1*pixelSize, y: offsetY + 3*pixelSize))
            checkPath.addLineToPoint(CGPoint(x: offsetX + 2*pixelSize, y: offsetY + 4*pixelSize))
            checkPath.addLineToPoint(CGPoint(x: offsetX + 4*pixelSize, y: offsetY + 2*pixelSize))
            checkPath.lineWidth = pixelSize*1.25
            checkPath.stroke()
            return;
        }
        
        //// Bezier Drawing (Picture Number)
        let size = selectionString.sizeWithAttributes(settings.selectionTextAttributes)
        
        selectionString.drawInRect(CGRectMake(CGRectGetMidX(checkmarkFrame) - size.width / 2.0,
            CGRectGetMidY(checkmarkFrame) - size.height / 2.0,
            size.width,
            size.height), withAttributes: settings.selectionTextAttributes)
    }
}
