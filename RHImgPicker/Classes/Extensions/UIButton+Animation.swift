//
//  UIButton+Animation.swift
//  Pods
//
//  Created by rizan on 29/08/2016.
//
//

import Foundation

extension UIButton {
    
    
    /*
    func playImplicitBounceAnimation() {
        
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = NSTimeInterval(0.5)
        bounceAnimation.calculationMode = kCAAnimationCubic
        
        layer.addAnimation(bounceAnimation, forKey: "bounceAnimation")
    }*/
    
    /*
    func playTapAnimation(from : CGColor , to : CGColor) {
        
        
        let tapAnimation = CABasicAnimation(keyPath: "backgroundColor")
        tapAnimation.fromValue = from
        tapAnimation.toValue = to
        tapAnimation.duration = NSTimeInterval(0.25)
        tapAnimation.autoreverses  = true
        
        self.layer.addAnimation(tapAnimation, forKey: "tapAnimation")
        
        
    }
    */
    
    
    
    /*
    func playExplicitBounceAnimation() {
        
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        var values = [Double]()
        let e = 2.71
        
        for t in 1..<100 {
            let value = 0.6 * pow(e, -0.045 * Double(t)) * cos(0.1 * Double(t)) + 1.0
            
            values.append(value)
        }
        
        
        bounceAnimation.values = values
        bounceAnimation.duration = NSTimeInterval(0.5)
        bounceAnimation.calculationMode = kCAAnimationCubic
        
        layer.addAnimation(bounceAnimation, forKey: "bounceAnimation")
    }
    
    */
       
}







let RHBT_TAG = 468

extension UIButton {
    
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        if self.tag == RHBT_TAG {
            if let subView = self.subviews.first , let backgroundColor = subView.backgroundColor  {
                if subView.tag == RHBT_TAG {
                    subView.backgroundColor = backgroundColor.colorWithAlphaComponent(0.3)
                }
            }
        }
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        if self.tag == RHBT_TAG {
            if let subView = self.subviews.first, let backgroundColor = subView.backgroundColor {
                if subView.tag == RHBT_TAG {
                    subView.backgroundColor = backgroundColor.colorWithAlphaComponent(0.0)
                }
            }
        }
    }
    
    
    override public func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        
        if self.tag == RHBT_TAG {
            if let subView = self.subviews.first, let backgroundColor = subView.backgroundColor {
                if subView.tag == RHBT_TAG {
                    subView.backgroundColor = backgroundColor.colorWithAlphaComponent(0.0)
                }
            }
        }
    }
    
    
    
}
