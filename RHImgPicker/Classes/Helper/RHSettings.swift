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
//  Settings.swift
//  Pods
//
//  Created by rizan on 26/08/2016.
//
//

import UIKit

/**
 The settings object that gets passed around between classes for keeping...settings
 */


private let sharedKraken = RHSettings()


final class RHSettings :  RHImgPickerSettings {
    
    
    class var sharedInstance: RHImgPickerSettings {
        
        return sharedKraken
    }

    private init() {
    
    
    }
    
    
    private var _maxNumberOfSelections: Int = Int.max - 1
    private var _selectionCharacter: Character? = nil
    
    
    private var _selectionFillColor: UIColor = UIColor.redColor()
    private var _selectionStrokeColor: UIColor = UIColor.whiteColor()
    private var _selectionShadowColor: UIColor = UIColor.blackColor()
    private var _selectionHighlightColor: UIColor = UIColor.whiteColor()
    
    
    
    private var _useToolBarButtons: Bool = true
    private var _toolBarButtonsBackgroundColor: UIColor =  UIColor.darkGrayColor()
    private var _toolBarButtonsFontColor: UIColor =  UIColor.lightTextColor()
    
    private var _buttonLabelFont: UIFont = UIFont.systemFontOfSize(25)
    
    private var _buttonColors: [UIColor] = [ UIColor.redColor(), UIColor.yellowColor(),UIColor.blueColor()]
    private var _buttonLabelFontColors: [UIColor] =  [UIColor.whiteColor(),UIColor.darkTextColor(), UIColor.whiteColor()]
    private var _buttonHighlightColors: [UIColor] =  [UIColor.whiteColor(),UIColor.whiteColor(), UIColor.whiteColor()]
    private var _buttonLabelTexts: [String] = ["Clear", "Album", "Done"]
    
    
    private var _selectionTextAttributes: [String: AnyObject] = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByTruncatingTail
        paragraphStyle.alignment = .Center
        return [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(10.0),
            NSParagraphStyleAttributeName: paragraphStyle,
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
    }()
    
    
    var _cellsPerRow: (verticalSize: UIUserInterfaceSizeClass, horizontalSize: UIUserInterfaceSizeClass) -> Int = {(verticalSize: UIUserInterfaceSizeClass, horizontalSize: UIUserInterfaceSizeClass) -> Int in
        switch (verticalSize, horizontalSize) {
        case (.Compact, .Regular): // iPhone5-6 portrait
            return 3
        case (.Compact, .Compact): // iPhone5-6 landscape
            return 5
        case (.Regular, .Regular): // iPad portrait/landscape
            return 7
        default:
            return 3
        }
    }
    
    
    private var _backgroundColor: UIColor = UIColor.darkGrayColor()
    
    private var _albumCellBackgroundColor: UIColor = UIColor.lightGrayColor()
    
    private var _albumCellLabelColor: UIColor = UIColor.darkGrayColor()
    
    
    
    
    private var _albumCellAnimation: ((layer: CALayer) -> Void) = { layer in
       
        layer.opacity = 0
        UIView.animateWithDuration(0.5, animations: {
            layer.opacity = 1
        })
    }
    
    
    
    
}



// MARK: RHSettings proxy
extension RHSettings {

    /**
     See RHImgPicketSettings for documentation
     */
    var maxNumberOfSelections: Int {
        get {
            return _maxNumberOfSelections
        }
        set {
            _maxNumberOfSelections = newValue
        }
    }

    
    /**
     See RHImgPicketSettings for documentation
     */
    var selectionCharacter: Character? {
        get {
            return _selectionCharacter
        }
        set {
            _selectionCharacter = newValue
        }
    }
    
    
    
    /**
     See RHImgPicketSettings for documentation
     */
    var selectionFillColor: UIColor {
        get {
            return _selectionFillColor
        }
        set {
            _selectionFillColor = newValue
        }
    }
    
    /**
     See RHImgPicketSettings for documentation
     */
    var selectionStrokeColor: UIColor {
        get {
            return _selectionStrokeColor
        }
        set {
            _selectionStrokeColor = newValue
        }
    }
    
    /**
     See RHImgPicketSettings for documentation
     */
    var selectionShadowColor: UIColor {
        get {
            return _selectionShadowColor
        }
        set {
            _selectionShadowColor = newValue
        }
    }
    
    /**
     See RHImgPicketSettings for documentation
     */
    var selectionHighlightColor: UIColor {
        get {
            return _selectionHighlightColor
        }
        set {
            _selectionHighlightColor = newValue
        }
    }
    
    
    
    /**
     See RHImgPicketSettings for documentation
     */
    var selectionTextAttributes: [String: AnyObject] {
        get {
            return _selectionTextAttributes
        }
        set {
            _selectionTextAttributes = newValue
        }
    }
    
    /**
     See RHImgPicketSettings for documentation
     */
    var cellsPerRow: (verticalSize: UIUserInterfaceSizeClass, horizontalSize: UIUserInterfaceSizeClass) -> Int {
        get {
            return _cellsPerRow
        }
        set {
            _cellsPerRow = newValue
        }
    }
    
    
    
    
    /**
     See RHImgPicketSettings for documentation
     */
    var useToolBarButtons : Bool {
        
        get {
            return _useToolBarButtons
        }
        set {
            _useToolBarButtons = newValue
        }
        
        
    }
    
    /**
     See RHImgPicketSettings for documentation
     */
    var toolBarButtonsFontColor : UIColor {
        
        get {
            return _toolBarButtonsFontColor
        }
        set {
            _toolBarButtonsFontColor = newValue
        }
        
        
    }
    
    
    /**
     See RHImgPicketSettings for documentation
     */
    var toolBarButtonsBackgroundColor : UIColor {
        
        get {
            return _toolBarButtonsBackgroundColor
        }
        set {
            _toolBarButtonsBackgroundColor = newValue
        }
        
        
    }
    
    
    
    
    /**
     See RHImgPicketSettings for documentation
     */
    var buttonColors : [UIColor] {
        
        get {
            return _buttonColors
        }
        set {
            
            if newValue.count == 3 {
                
                _buttonColors = newValue
            }
            else {
                
                logInvalidArrayLenthFor( "buttonColors" , type :"UIColor", lenth: 3)
            }
            
        }
        
        
    }
    
    
    /**
     See RHImgPicketSettings for documentation
     */
    var buttonLabelFont : UIFont {
        
        get {
            return _buttonLabelFont
        }
        set {
            _buttonLabelFont = newValue
        }
        
        
    }
    
    /**
     See RHImgPicketSettings for documentation
     */
    var buttonLabelFontColors : [UIColor] {
        
        get {
            return _buttonLabelFontColors
        }
        set {
            
            if newValue.count == 3 {
                
                _buttonLabelFontColors = newValue
            }
            else {
                
               logInvalidArrayLenthFor( "buttonLabelFontColors" , type :"UIColor", lenth: 3)
            }
            
        }
        
        
    }
    
    
    
    
    
    /**
     See RHImgPicketSettings for documentation
     */
    var buttonHighlightColors : [UIColor] {
        
        get {
            return _buttonHighlightColors
        }
        set {
            
            if newValue.count == 3 {
                
                _buttonHighlightColors = newValue
            }
            else {
                
                logInvalidArrayLenthFor( "buttonHighlightColors" , type :"UIColor", lenth: 3)
            }
            
        }
        
        
    }
    
    
    
    
    /**
     * See RHImgPicketSettings for documentation
     * buttonLabelTexts : [String (lenth = 3)] 
     * default value ["Clear", "Album", "Done"]
     */
    var buttonLabelTexts : [String] {
        
        get {
            return _buttonLabelTexts
        }
        set {
            
            
            if newValue.count == 3 {
                _buttonLabelTexts = newValue
            }
            else {
                logInvalidArrayLenthFor( "buttonLabelText" , type :"String", lenth: 3)
            }
        }
        
    }
    
    
    /**
     See RHImgPicketSettings for documentation
     */
    var backgroundColor: UIColor {
        get {
            return _backgroundColor
        }
        set {
            _backgroundColor = newValue
        }
    }

    
    /**
     See RHImgPicketSettings for documentation
     */
    var albumCellBackgroundColor: UIColor {
        get {
            return _albumCellBackgroundColor
        }
        set {
            _albumCellBackgroundColor = newValue
        }
    }
    
    
    /**
     See RHImgPicketSettings for documentation
     */
    var albumCellLabelColor: UIColor {
        get {
            return _albumCellLabelColor
        }
        set {
            _albumCellLabelColor = newValue
        }
    }
    

    /**
     See RHImgPicketSettings for documentation
     */
    var albumCellAnimation: ((layer: CALayer) -> Void) {
        get {
            return _albumCellAnimation
        }
        set {
            _albumCellAnimation = newValue
        }
    }

    
    /**
     See RHImgPicketSettings for documentation
     */
    func setAlbumCellAnimation ( animationBlock: ((layer: CALayer) -> Void) ) {
    
        _albumCellAnimation = animationBlock
    }
    
    
    private func logInvalidArrayLenthFor(property : String  , type : String ,  lenth : Int) {
    
        print("ERROR : cannot set value for property  -->  [\(property)]. must be --> { [\(type) (lenth = \(lenth) )] }.")
    
    }

}




