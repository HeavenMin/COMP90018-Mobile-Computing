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
    //
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
//
//    @IBAction func logIn(_ sender: UIButton) {
//        table?.read { (result, error) in
//            if let err = error {
//                print("ERROR ", err)
//            } else if let items = result?.items {
//                for item in items {
//                    print("Todo Item: ", item["text"] ?? "None")
//                }
//            }
//        }
//    }
//
//    @IBAction func signUp(_ sender: UIButton) {
//        if (isSignUp)
//        {
//            if let username = userName.text{
//                if let password = passWord.text{
//                    if let repeatpassword = passWordRepeat.text{
//                        if password == repeatpassword {
//                            let newItem = ["UserName":username,"PassWord":password] as [String: Any]
//                            table?.insert(newItem){ (result, error) in
//                                if let err = error {
//                                    print("ERORR",err)
//                                } else if let item = result{
//                                    print("UserName",item["UserName"] ?? "None")
//                                }
//                            }
//                        }
//                        else{
//                            textInfo.text = "The password must match"
//                        }
//                    }
//                }
//            }else{
//                textInfo.text = "Please input your username and password"
//            }
////            let newItem = ["UserName":userName.text!, "PassWord":kcal] as [String : Any]
////            print(userName.text!,passWord.text!)
////            table?.insert(newItem) { (result, error) in
////                if let err = error {
////                    print("ERROR ", err)
////                } else if let item = result {
////                    print("Todo Item: ", item["USERNAME"] ?? "Fault")
////                }
////            }
//        }
//        else{
//            passWordRepeat.isHidden = false
//            isSignUp = true
//        }
//
    
}
