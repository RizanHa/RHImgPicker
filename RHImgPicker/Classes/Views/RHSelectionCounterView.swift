//
//  SelectionCounterView.swift
//  Pods
//
//  Created by rizan on 30/08/2016.
//
//

import Foundation




/**
 Used as an overlay on selected cells
 */
@IBDesignable final class RHSelectionCounterView: UIView {
    
    
    
    //MARK: - SelectionView
    
    
    var selectionCounterString: String = "" {
        didSet {
            if selectionCounterString != oldValue {
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
        let checkmarkFrame = self.bounds;
        
        
        
        /// estimate size for rounded rect
        let stringToDraw = selectionCounterString + "/" + String(settings.maxNumberOfSelections)
        let size = stringToDraw.sizeWithAttributes(settings.selectionTextAttributes)
        
        let stringToDrawLength = NSString.init(string: stringToDraw).length
        
        var offsetH = rect.size.height*0.125
        var offset = rect.size.height*0.125
        
        if stringToDrawLength == 6 {
            offset = rect.size.height*0.1
        } else if (stringToDrawLength >= 7) {
            offset = rect.size.height*0.05
        }
        
    
        
        
        //// path for Drawing
        let checkedROundedRectPath = UIBezierPath(roundedRect: CGRectMake(rect.origin.x + offset, rect.origin.y + offsetH, rect.size.width - 2*offset , rect.size.height - 2*offsetH), cornerRadius: rect.size.height*0.25)
        
        CGContextSaveGState(context)
        CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, settings.selectionShadowColor.CGColor)
        settings.selectionFillColor.setFill()
        checkedROundedRectPath.fill()
        CGContextRestoreGState(context)
        
        settings.selectionStrokeColor.setStroke()
        checkedROundedRectPath.lineWidth = 1
        checkedROundedRectPath.stroke()
        
        
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        
        //// Check mark for single assets
        if (settings.maxNumberOfSelections == 1) {
            CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
            
            let pixelSize = rect.size.height / 8
            let offsetX = pixelSize*4.0
            let offsetY = pixelSize*1.0
            
            
            let checkPath = UIBezierPath()
            checkPath.moveToPoint(CGPoint(x: offsetX + 1*pixelSize, y: offsetY + 3*pixelSize))
            checkPath.addLineToPoint(CGPoint(x: offsetX + 2*pixelSize, y: offsetY + 4*pixelSize))
            checkPath.addLineToPoint(CGPoint(x: offsetX + 4*pixelSize, y: offsetY + 2*pixelSize))
            checkPath.lineWidth = pixelSize*1.25
            checkPath.stroke()
            return
        }
        
        ////  Drawing string
  
        stringToDraw.drawInRect(CGRectMake(CGRectGetMidX(checkmarkFrame) - size.width / 2.0,
            CGRectGetMidY(checkmarkFrame) - size.height / 2.0,
            size.width,
            size.height), withAttributes: settings.selectionTextAttributes)
    }
}
