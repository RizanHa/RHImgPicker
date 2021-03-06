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
//  RHAnimator.swift
//  Pods
//
//  Created by rizan on 26/08/2016.
//
//


import UIKit

final class RHAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    var sourceImageView: UIImageView?
    var destinationImageView: UIImageView?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Get to and from view controller
        if let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to), let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from), let sourceImageView = sourceImageView, let destinationImageView = destinationImageView {
            
            let containerView = transitionContext.containerView
            
            // Disable selection so we don't select anything while the push animation is running
            fromViewController.view?.isUserInteractionEnabled = false
            
            // Setup views
            sourceImageView.isHidden = true
            destinationImageView.isHidden = true
            toViewController.view.alpha = 0.0
            fromViewController.view.alpha = 1.0
            containerView.backgroundColor = toViewController.view.backgroundColor
            
            // Setup scaling image
            let scalingFrame = containerView.convert(sourceImageView.frame, from: sourceImageView.superview)
            let scalingImage = ImgViewScaleAspect(frame: scalingFrame)
            scalingImage.img.contentMode = sourceImageView.contentMode
            scalingImage.img.image = sourceImageView.image
            
            //Init image scale
            let destinationFrame = toViewController.view.convert(destinationImageView.bounds, from: destinationImageView.superview)
            if destinationImageView.contentMode == .scaleAspectFit {
                scalingImage.initToScaleAspectFitToFrame(destinationFrame)
            } else {
                scalingImage.initToScaleAspectFillToFrame(destinationFrame)
            }
            
            // Add views to container view
            containerView.addSubview(toViewController.view)
            containerView.addSubview(scalingImage)
            
            // Animate
            UIView.animate(withDuration: transitionDuration(using: transitionContext),
                                       delay: 0.0,
                                       options: UIViewAnimationOptions(),
                                       animations: { () -> Void in
                                        // Fade in
                                        fromViewController.view.alpha = 0.0
                                        toViewController.view.alpha = 1.0
                                        
                                        if destinationImageView.contentMode == .scaleAspectFit {
                                            scalingImage.animaticToScaleAspectFit()
                                        } else {
                                            scalingImage.animaticToScaleAspectFill()
                                        }
                }, completion: { (finished) -> Void in
                    
                    // Finish image scaling and remove image view
                    if destinationImageView.contentMode == .scaleAspectFit {
                        scalingImage.animateFinishToScaleAspectFit()
                    } else {
                        scalingImage.animateFinishToScaleAspectFill()
                    }
                    scalingImage.removeFromSuperview()
                    
                    // Unhide
                    destinationImageView.isHidden = false
                    sourceImageView.isHidden = false
                    fromViewController.view.alpha = 1.0
                    
                    // Finish transition
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    
                    // Enable selection again
                    fromViewController.view?.isUserInteractionEnabled = true
            })
        }
    }
}
