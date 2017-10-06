//
//  LogInAndSignUp.swift
//  KeepFit
//
//  Created by 纪凯夫 on 2017/10/5.
//  Copyright © 2017年 Min Gao. All rights reserved.
//

import Foundation
import UIKit

class LogInAndSignUp: ViewController {
    override func viewDidLoad() {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if ((UIApplication.shared.delegate) as! AppDelegate).isLogin {
            dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
}
class LogInViewController:ViewController{
    
    override func viewDidLoad() {
        passWord.isSecureTextEntry = true
    }
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var alertText: UITextView!
    @IBOutlet weak var passWord: UITextField!
    @IBAction func submit(_ sender: UIButton) {
        if let user_name = userName.text {
            if let pass_word = passWord.text{
                let client = ((UIApplication.shared.delegate) as! AppDelegate).client!
                let table = client.table(withName: "UserInfo")
                let predicate =  NSPredicate(format: "(UserName == \"\(user_name)\") AND (PassWord == \"\(pass_word)\")")
                table.read(with: predicate) { (result, error) in
                    if let err = error {
                        print("ERROR ", err)
                    } else if let items = result?.items {
                        if items.count == 1 {
                            ((UIApplication.shared.delegate) as! AppDelegate).userName = items[0]["UserName"] as! String
                            ((UIApplication.shared.delegate) as! AppDelegate).isLogin = true
                            self.dismiss(animated: false, completion: nil)
                        }
                        else{
                            self.alertText.text = "Incorrect Username or password"
                        }
                    }
                }
                
            }else{
                alertText.text = "You need input your password\n"
            }
        }
        else{
            alertText.text = "You need input your username\n"
        }
        
    }
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

class SignUpViewController: ViewController {
    
    override func viewDidLoad() {
        passWord.isSecureTextEntry = true
        passWordRepeat.isSecureTextEntry = true
    }
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var passWordRepeat: UITextField!
    @IBOutlet weak var alertText: UITextView!
    @IBAction func submit(_ sender: UIButton) {
        if let user_name = userName.text {
            if let pass_word = passWord.text{
                if let pass_word_repeat = passWordRepeat.text {
                    if (pass_word == pass_word_repeat){
                        let client = ((UIApplication.shared.delegate) as! AppDelegate).client!
                        let table = client.table(withName: "UserInfo")
                        let predicate =  NSPredicate(format: "(UserName == \"\(user_name)\")")
                        table.read(with:predicate){ (result,error) in
                            if let err = error{
                                print(err)
                            }else if let items = result?.items{
                                if items.count > 0 {
                                    self.alertText.text = "Username has already been used choose another one"
                                }
                                else{
                                    let newItem = ["UserName":user_name, "PassWord":pass_word] as [String : Any]
                                    table.insert(newItem) { (result, error) in
                                        if let err = error {
                                            print("ERROR ", err)
                                        } else if let item = result {
                                            print("Todo Item: ", item["UserName"] ?? "Fault")
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                    }
                                }
                            }
                        }
                    }else{
                        alertText.text = "password must match"
                    }
                }
            }
        }
    }
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
