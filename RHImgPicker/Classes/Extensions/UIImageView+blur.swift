//
//  UIImageView+bluer.swift
//  Pods
//
//  Created by rizan on 29/08/2016.
//
//

import UIKit


//MARK: - UIImageView extension blurImage

extension UIImageView{
    
    func blurImage(_ style: UIBlurEffectStyle)
    {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}

