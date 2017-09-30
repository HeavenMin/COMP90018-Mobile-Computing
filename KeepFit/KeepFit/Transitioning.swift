//
//  TransitioningObject.swift
//  KeepFit
//
//  Created by Min Gao on 2017/8/30.
//  Copyright © 2017年 Min Gao. All rights reserved.
//

import UIKit

//for switching tabs with an animation
class Transitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromView: UIView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView: UIView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        transitionContext.containerView.addSubview(fromView)
        transitionContext.containerView.addSubview(toView)
        
        UIView.transition(from: fromView, to: toView, duration: transitionDuration(using: transitionContext), options: UIViewAnimationOptions.transitionCrossDissolve) { finished in
            transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
}
