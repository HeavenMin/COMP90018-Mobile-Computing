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
        let newItem = ["UserName":user_name, "RunRecord":"firstRun","Calorie":1000,"Distance":distance] as [String : Any]
        run_table?.insert(newItem) { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if result != nil {
                print("Success insert fitness record")
            }
        }
    }
    func insertFoodRecord(food_name:String,calorie:Double){
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
                    let c = String(describing: item["createdAt"].unsafelyUnwrapped)
                    let startSlicingIndex = c.index(c.startIndex, offsetBy: 10)
                    let date1 = c[c.startIndex..<startSlicingIndex]
                    if self.nowTime == date1 {
                        dis += item["Distance"] as! Double
                    }
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
                    let c = String(describing: item["createdAt"].unsafelyUnwrapped)
                    let startSlicingIndex = c.index(c.startIndex, offsetBy: 10)
                    let date1 = c[c.startIndex..<startSlicingIndex]
                    if self.nowTime == date1 {
                        cal += item["Quantity"] as! Double
                    }
                }
                label.text = "\(cal)"
            }
        }
    }
    
}
