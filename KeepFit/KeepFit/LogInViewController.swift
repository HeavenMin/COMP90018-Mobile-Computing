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
    
    @IBAction func Detail(_ sender: UIButton) {
        let client = ((UIApplication.shared.delegate) as! AppDelegate).client!
        let calorie_table = client.table(withName: "UserFoodInfo")
        let run_table = client.table(withName: "UserFitnessRecord")
        let newItem = ["UserName":"admin", "FoodName":"banana","Quantity":1000] as [String : Any]
        calorie_table.insert(newItem) { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if let item = result {
                print("Todo Item: ", item["UserName"] ?? "Fault")
                self.dismiss(animated: true, completion: nil)
            }
        }
        let newItem1 = ["UserName":"admin", "RunRecord":"firstRun","Calorie":1000,"Distance":3.3] as [String : Any]
        run_table.insert(newItem1) { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if let item = result {
                print("Todo Item: ", item["UserName"] ?? "Fault")
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    
    @IBOutlet weak var run_label: UILabel!
    @IBOutlet weak var calorie_label: UILabel!
    
    @IBOutlet weak var userInfo: UILabel!
    
    override func viewDidLoad() {
        //        passWordRepeat.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if !((UIApplication.shared.delegate) as! AppDelegate).isLogin {
            userInfo.text = "Visitor"
            run_label.text = ""
            calorie_label.text = ""
        }
        else{
            let username = ((UIApplication.shared.delegate) as! AppDelegate).userName!
            userInfo.text = username
            let client = ((UIApplication.shared.delegate) as! AppDelegate).client!
            let calorie_table = client.table(withName: "UserFoodInfo")
            let run_table = client.table(withName: "UserFitnessRecord")
            print(username)
            let predicate =  NSPredicate(format: "(UserName == \"\(username)\")")
            calorie_table.read(with:predicate){ (result,error) in
                if let err = error{
                    print(err)
                }else if let items = result?.items{
                    var cal = 0
                    for item in items{
                        cal += item["Quantity"] as! Int
                    }
                    self.calorie_label.text = "\(cal)"
                }
            }
            let predicate1 =  NSPredicate(format: "(UserName == \"\(username)\")")
            run_table.read(with:predicate1){ (result,error) in
                if let err = error{
                    print(err)
                }else if let items = result?.items{
                    var dis = 0.0
                    for item in items{
                        dis += item["Distance"] as! Double
                    }
                    self.run_label.text = "\(dis)"
                }
            }
        }
    }
    
    @IBAction func userInfo_checking(_ sender: UIButton) {
        if !((UIApplication.shared.delegate) as! AppDelegate).isLogin {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInAndSignUp") as! LogInAndSignUp
            present(vc, animated: true, completion: nil)
        }else{
            let logOutAlert = UIAlertController(title:"Log Out",message:"tap Ok to log out tap cancel to return",preferredStyle:UIAlertControllerStyle.alert)
            let logOutAction = UIAlertAction(title:"OK",style: .default,handler:{
                action in
                ((UIApplication.shared.delegate) as! AppDelegate).isLogin = false
                ((UIApplication.shared.delegate) as! AppDelegate).userName = ""
                self.userInfo.text = "Visitor"
                self.run_label.text = ""
                self.calorie_label.text = ""
            })
            let cancelAction = UIAlertAction(title:"cancel",style: UIAlertActionStyle.cancel,handler:nil)
            logOutAlert.addAction(logOutAction)
            logOutAlert.addAction(cancelAction)
            present(logOutAlert, animated: true, completion: nil)
            
        }
    }
    
    
}
