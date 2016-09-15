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
    
    var imageView: UIImageView = UIImageView()
    var selectionOverlayView: UIView = UIView()
    var selectionView: SelectionView = SelectionView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView.contentMode = .scaleAspectFill
        
        self.selectionView.backgroundColor = UIColor.clear
        self.selectionOverlayView.backgroundColor = RHSettings.sharedInstance.selectionHighlightColor
        
        
        self.selectionOverlayView.alpha = 0.0
        
        
        self.clipsToBounds = true
        self.imageView.clipsToBounds = true
        self.selectionOverlayView.clipsToBounds = true
        self.selectionView.clipsToBounds = true
        
        
        self.addSubview(imageView)
        self.addSubview(selectionOverlayView)
        self.addSubview(selectionView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }


  
    
    
    
    func layoutCell() {
        
        let frame : CGRect = self.frame
        let sizeSelectionViewXY = self.frame.size.height*0.35
        
        self.imageView.frame = CGRect(x: 0,
                                      y: 0,
                                      width: frame.size.width,
                                      height: frame.size.height)
        
        self.selectionOverlayView.frame = CGRect(x: 0,
                                                 y: 0,
                                                 width: frame.size.width,
                                                 height: frame.size.height)
        
        self.selectionView.frame = CGRect(x: frame.size.width -  sizeSelectionViewXY*1.15,
                                          y: frame.size.height - sizeSelectionViewXY*1.15 ,
                                          width: sizeSelectionViewXY ,
                                          height: sizeSelectionViewXY )
        
        
        
        
    }
    
    
    
    //MARK: -
    
    
    func updata(_ index : Int) {
    
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
    
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        
        set {
            let hasChanged = isSelected != newValue
            super.isSelected = newValue
            
            if UIView.areAnimationsEnabled && hasChanged {
                UIView.animate(withDuration: TimeInterval(0.1), animations: { () -> Void in
                    // Set alpha for views
                    self.updateAlpha(newValue)
                    
                    // Scale all views down a little
                    self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }, completion: { (finished: Bool) -> Void in
                    UIView.animate(withDuration: TimeInterval(0.1), animations: { () -> Void in
                        // And then scale them back upp again to give a bounce effect
                        self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        }, completion: nil)
                }) 
            } else {
                updateAlpha(newValue)
            }
        }
    }
    
    fileprivate func updateAlpha(_ selected: Bool) {
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
    
    
    override func draw(_ rect: CGRect) {
        
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
        let group = CGRect(x: checkmarkFrame.minX + 3, y: checkmarkFrame.minY + 3, width: checkmarkFrame.width - 6, height: checkmarkFrame.height - 6)
        
        //// CheckedOval Drawing
        let checkedOvalPath = UIBezierPath(ovalIn: CGRect(x: group.minX + floor(group.width * 0.0 + 0.5), y: group.minY + floor(group.height * 0.0 + 0.5), width: floor(group.width * 1.0 + 0.5) - floor(group.width * 0.0 + 0.5), height: floor(group.height * 1.0 + 0.5) - floor(group.height * 0.0 + 0.5)))
        context?.saveGState()
        context?.setShadow(offset: shadow2Offset, blur: shadow2BlurRadius, color: settings.selectionShadowColor.cgColor)
        settings.selectionFillColor.setFill()
        checkedOvalPath.fill()
        context?.restoreGState()
        
        settings.selectionStrokeColor.setStroke()
        checkedOvalPath.lineWidth = 1
        checkedOvalPath.stroke()
        
        
        context?.setFillColor(UIColor.white.cgColor)
        
        //// Check mark for single assets
        if (settings.maxNumberOfSelections == 1) {
            context?.setStrokeColor(UIColor.white.cgColor)
            
            let pixelSize = rect.size.height / 8
            let offsetX = pixelSize*1.5
            let offsetY = pixelSize*1.0
            
            
            let checkPath = UIBezierPath()
            checkPath.move(to: CGPoint(x: offsetX + 1*pixelSize, y: offsetY + 3*pixelSize))
            checkPath.addLine(to: CGPoint(x: offsetX + 2*pixelSize, y: offsetY + 4*pixelSize))
            checkPath.addLine(to: CGPoint(x: offsetX + 4*pixelSize, y: offsetY + 2*pixelSize))
            checkPath.lineWidth = pixelSize*1.25
            checkPath.stroke()
            return;
        }
        
        //// Bezier Drawing (Picture Number)
        let size = selectionString.size(attributes: settings.selectionTextAttributes)
        
        selectionString.draw(in: CGRect(x: checkmarkFrame.midX - size.width / 2.0,
            y: checkmarkFrame.midY - size.height / 2.0,
            width: size.width,
            height: size.height), withAttributes: settings.selectionTextAttributes)
    }
}
