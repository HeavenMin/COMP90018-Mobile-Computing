//
//  FoodDatabaseAzureOperation.swift
//  KeepFit
//
//  Created by Min Gao on 2017/9/20.
//  Copyright © 2017年 Min Gao. All rights reserved.
//

import Foundation

//usually this database is used to read the food information
class FoodDatabaseAzureOperation {
    
    var client: MSClient?
    var foodTable: MSTable?
    
    init() {
        client = ((UIApplication.shared.delegate) as! AppDelegate).client!
        foodTable = self.client?.table(withName: "FoodInfo")
    }
    
    //using closure
    func queryForKcal(food_name: String, completion: @escaping (_ kcal: Int) -> Void) {
        let predicate =  NSPredicate(format: "foodName == \"\(food_name)\"")
        
        var kcal = -1
        
        foodTable?.read(with: predicate) { (result, error) in
            if let err = error {
                print("ERROR ", err)
                completion(kcal)
            } else if let items = result?.items {
                for item in items {
                    print("kcal of \(item["foodName"]!):", item["kcal"]!)
                    kcal = item["kcal"] as! Int
                    completion(kcal)
                }
            }
            completion(kcal)
        }
        
    }
    
    //this fuc can tell whether insert operation success or not
    func insertKcal(food_name: String, kcal: Int, completion: @escaping (_ success: Bool) -> Void) {
        
        let item = ["foodName":food_name, "kcal":kcal] as [String : Any]
        self.foodTable?.insert(item) { (result, error) in
            if let err = error {
                print("ERROR ", err)
                completion(false)
            } else if let item = result {
                print("Food calorie insert success: ", item["foodName"]!)
                print("Food kcal:", item["kcal"]!)
                completion(true)
            }
        }
    }
    
    //inset the food data into the azure database, barely use
    func insert(food_name: String, kcal: Int) {
        
        let item = ["foodName":food_name, "kcal":kcal] as [String : Any]
        self.foodTable?.insert(item) { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if let item = result {
                print("Food calorie insert success: ", item["foodName"]!)
                print("Food kcal:", item["kcal"]!)
            }
        }
        
    }
    
    //old method, cannot deal with block call back problem.
    func queryForKcalOldMethod(food_name: String) -> Int {
        
        let predicate =  NSPredicate(format: "foodName == \"\(food_name)\"")
        // Query the table
        var kcal = 0
        
        foodTable?.read(with: predicate) { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if let items = result?.items {
                for item in items {
                    print("kcal of \(item["foodName"]!):", item["kcal"]!)
                    kcal = item["kcal"] as! Int
                }
            }
        }
        return kcal
    }
    
}
