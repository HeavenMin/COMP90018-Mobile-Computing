//
//  KeepFitTabBarController.swift
//  KeepFit
//
//  Created by Min Gao on 2017/8/30.
//  Copyright © 2017年 Min Gao. All rights reserved.
//

import UIKit

//for switching tabs with an animation
class KeepFitTabBarController: UITabBarController, UITabBarControllerDelegate {

     override func viewDidLoad() {
        
        super.viewDidLoad()
        self.delegate = self
        
    }

    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Transitioning()
    }
}
