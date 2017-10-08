//
//  AzureOperation.swift
//  KeepFit
//
//  Created by 纪凯夫 on 2017/10/7.
//  Copyright © 2017年 Min Gao. All rights reserved.
//

import Foundation
class AzureOperation {
    
    var client: MSClient?
    var calorie_table: MSTable?
    var run_table: MSTable?
    var user_name: String
    var nowTime: String
    
    init() {
        client = ((UIApplication.shared.delegate) as! AppDelegate).client!
        calorie_table = self.client?.table(withName: "UserFoodInfo")
        run_table = self.client?.table(withName: "UserFitnessRecord")
        user_name = ((UIApplication.shared.delegate) as! AppDelegate).userName!
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd"
        nowTime = timeFormatter.string(from: date)
    }
    func insertDistanceRecord(distance:Double) {
        if !((UIApplication.shared.delegate) as! AppDelegate).isLogin {
            print("log in first")
            return
        }
        let newItem = ["UserName":user_name, "RunRecord":"firstRun","Calorie":1000,"Distance":distance,"RunStartTime":Date()] as [String : Any]
        run_table?.insert(newItem) { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if result != nil {
                print("Success insert fitness record")
            }
        }
    }
    func insertFoodRecord(food_name:String,calorie:Double){
        if !((UIApplication.shared.delegate) as! AppDelegate).isLogin {
            return
        }
        let newItem = ["UserName":user_name, "FoodName":food_name,"Quantity":calorie,"EatTime":Date()] as [String : Any]
        calorie_table?.insert(newItem) { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if result != nil {
                print("Success insert food record")
            }
        }
    }
    func queryDistance(label:UILabel) {
        var dis = 0.0
        let predicate1 =  NSPredicate(format: "(UserName == \"\(user_name)\")")
        run_table?.read(with:predicate1){ (result,error) in
            if let err = error{
                print(err)
            }else if let items = result?.items{
                for item in items{
                    let c = item["RunStartTime"] as!Date
                    if Calendar.current.isDateInToday(c){
                        dis += item["Distance"] as! Double
                    }
                }
                label.text = String(format: "%.2f", dis / 1000)
            }
        }
    }
    func queryCalorie(label:UILabel)  {
        var cal = 0.0
        let predicate =  NSPredicate(format: "(UserName == \"\(user_name)\")")
        calorie_table?.read(with:predicate){ (result,error) in
            if let err = error{
                print(err)
            }else if let items = result?.items{
                for item in items{
                    let c = item["EatTime"] as!Date
                    if Calendar.current.isDateInToday(c){
                        cal += item["Quantity"] as! Double
                    }
                }
                label.text = "\(cal)"
            }
        }
    }
    
}
