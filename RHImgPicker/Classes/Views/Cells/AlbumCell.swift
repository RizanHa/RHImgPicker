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
//  AlbumCell.swift
//  Pods
//
//  Created by rizan on 27/08/2016.
//
//


import UIKit

/**
 Cell for photo albums in the albums drop down menu
 */
final class AlbumCell: UITableViewCell {
    
    
    class var IDENTIFIER: String {
        return "AlbumCell_IDENTIFIER"
    }
 
    class var HEIGHT: CGFloat {
        
        return 80
    }

    
    var firstImageView: UIImageView = UIImageView()
    var secondImageView: UIImageView = UIImageView()
    var thirdImageView: UIImageView = UIImageView()
    var albumTitleLabel: UILabel = UILabel()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
        self.selectionStyle = UITableViewCellSelectionStyle.gray
        self.isUserInteractionEnabled = true
        self.clipsToBounds = true
        self.backgroundColor = RHSettings.sharedInstance.albumCellBackgroundColor
        
        
        // Add a little shadow to images views
        for imageView in [firstImageView, secondImageView, thirdImageView] {
            
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.layer.shadowColor = UIColor.white.cgColor
            imageView.layer.shadowRadius = 1.0
            imageView.layer.shadowOffset = CGSize(width: 0.5, height: -0.5)
            imageView.layer.shadowOpacity = 1.0
            self.addSubview(imageView)
        }
        
        
        
        self.albumTitleLabel.textAlignment = .left
        self.albumTitleLabel.textColor = RHSettings.sharedInstance.albumCellLabelColor
        self.addSubview(albumTitleLabel)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    func layoutCell() {
    
        var offset : CGFloat = 0
        let imgSizeXY = AlbumCell.HEIGHT*0.8
        let imgSizeOffset = AlbumCell.HEIGHT*0.1 - AlbumCell.HEIGHT*0.025
        
        
        // Add a little shadow to images views
        for imageView in [firstImageView, secondImageView, thirdImageView] {
            imageView.frame = CGRect(x: imgSizeOffset + offset, y: imgSizeOffset + offset, width: imgSizeXY, height: imgSizeXY)
            offset = offset + AlbumCell.HEIGHT*0.025
        }
        
        self.albumTitleLabel.frame = CGRect(x: imgSizeXY*2, y: 0, width: self.frame.size.width - imgSizeXY*2, height: AlbumCell.HEIGHT)

    }
    
    
    
    
    
}
