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
    
    init() {
        client = ((UIApplication.shared.delegate) as! AppDelegate).client!
        calorie_table = self.client?.table(withName: "UserFoodInfo")
        run_table = self.client?.table(withName: "UserFitnessRecord")
        user_name = ((UIApplication.shared.delegate) as! AppDelegate).userName!
    }
    func insertDistanceRecord(distance:Float) {
        let newItem = ["UserName":user_name, "RunRecord":"firstRun","Calorie":1000,"Distance":distance] as [String : Any]
        run_table?.insert(newItem) { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if result != nil {
                print("Success insert fitness record")
            }
        }
    }
    func insertFoodRecord(food_name:String,calorie:Float){
        let newItem = ["UserName":user_name, "FoodName":food_name,"Quantity":calorie] as [String : Any]
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
                    dis += item["Distance"] as! Double
                }
                label.text = "\(dis)"
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
                    let a = item["Quantity"] as! Double
                    cal += a
                }
                label.text = "\(cal)"
            }
        }
    }
    
}
