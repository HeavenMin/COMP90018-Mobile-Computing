//
//  ScaleController.swift
//  KeepFit
//
//  Created by Min Gao on 2017/10/4.
//  Copyright © 2017年 Min Gao. All rights reserved.
//

import UIKit

//for scale, max weight 400g
class ScaleController: UIViewController {
    
    @IBOutlet weak var weightLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        weightLabel.text = "0 g"
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    @IBAction func close_button(_ sender: Any) {
        
//        let transition = CATransition()
//        transition.duration = 0.2
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromTop
//        view.window!.layer.add(transition, forKey: kCATransition)
//        self.dismiss(animated: false, completion: nil)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //override the touchesMoved to implement the scale
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let force_touch = touches.first {
            if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
                if force_touch.force >= force_touch.maximumPossibleForce {
                    weightLabel.text = "400 g"
                } else {
                    let force = force_touch.force / force_touch.maximumPossibleForce
                    let grams = force * 400
                    let roundGrams = Int(grams)
                    weightLabel.text = "\(roundGrams) g"
                }
            }
        }
    }
    
    //when touch ended, init the weightLabel
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        weightLabel.text = "0 g"
    }
    
}
