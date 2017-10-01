//
//  ViewController.swift
//  Keep_Imitate_APP
//
//  Created by Lang LIN on 25/09/2017.
//  Copyright © 2017 Lang LIN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    @IBAction func JumpToMap(_ sender: Any) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//        let mapViewController = storyBoard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
//        self.present(mapViewController, animated:true, completion:nil)
//    }

    @IBAction func JumpToRunningView(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let mapViewController = storyBoard.instantiateViewController(withIdentifier: "RunningViewController") as! RunningViewController
        self.present(mapViewController, animated:true, completion:nil)
    }
    
    
    @IBAction func JumpToFoodView(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let mapViewController = storyBoard.instantiateViewController(withIdentifier: "FoodViewController") as! FoodViewController
        self.present(mapViewController, animated:true, completion:nil)
    }
}
