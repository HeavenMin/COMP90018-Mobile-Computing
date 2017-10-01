//
//  FoodViewController.swift
//  Keep_Imitate_APP
//
//  Created by Lang LIN on 01/10/2017.
//  Copyright © 2017 Lang LIN. All rights reserved.
//

import UIKit

class FoodViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func BackToBaseView(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let mapViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(mapViewController, animated:true, completion:nil)
    }
    
    
    @IBAction func JumpToCalorieCaculationView(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let mapViewController = storyBoard.instantiateViewController(withIdentifier: "CalorieCaculationViewController") as! CalorieCaculationViewController
        self.present(mapViewController, animated:true, completion:nil)
    }
    
    
    @IBAction func JumpToCameraView(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let mapViewController = storyBoard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        self.present(mapViewController, animated:true, completion:nil)
    }
    
    
    
}
