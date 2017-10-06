//
//  LogInViewController.swift
//  KeepFit
//
//  Created by 纪凯夫 on 2017/10/4.
//  Copyright © 2017年 Min Gao. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: ViewController {
    

    

    @IBOutlet weak var userInfo: UILabel!
    
    override func viewDidLoad() {
        //        passWordRepeat.isHidden = true
//        client = ((UIApplication.shared.delegate) as! AppDelegate).client!
//        table = client?.table(withName: "UserInfo")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if !((UIApplication.shared.delegate) as! AppDelegate).isLogin {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInAndSignUp") as! LogInAndSignUp
            present(vc, animated: true, completion: nil)
        }else{
            userInfo.text = ((UIApplication.shared.delegate) as! AppDelegate).userName
        }
    }

    
}
