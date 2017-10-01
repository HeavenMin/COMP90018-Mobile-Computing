//
//  FoodDatabase.swift
//  KeepFit
//
//  Created by Min Gao on 2017/9/20.
//  Copyright © 2017年 Min Gao. All rights reserved.
//

import Foundation

//usually this database is used to read the food information
class FoodDatabaseAzureOperation {
    
    var client: MSClient?
    var itemTable: MSTable?
    
    init() {
        client = ((UIApplication.shared.delegate) as! AppDelegate).client!
        itemTable = self.client?.table(withName: "FoodInfo")
    }
    
    //inset the food data into the azure database, barely use
    func insert(food_name: String, kcal: Int) {

        let item = ["foodName":food_name, "kcal":kcal] as [String : Any]
        self.itemTable?.insert(item) { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if let item = result {
                print("Todo Item: ", item["foodName"]!)
            }
        }
        
    }
    
    //old method, cannot deal with block call back problem.
    func queryForKcalOldMethod(food_name: String) -> Int {
        
        let predicate =  NSPredicate(format: "foodName == \"\(food_name)\"")
        // Query the table
        var kcal = 0
        
        itemTable?.read(with: predicate) { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if let items = result?.items {
                for item in items {
                    print("Todo Item: ", item["kcal"]!)
                    kcal = item["kcal"] as! Int
                }
            }
        }
        return kcal
    }
    
    //using closure
    func queryForKcal(food_name: String, completion: @escaping (_ kcal: Int) -> Void) {
        let predicate =  NSPredicate(format: "foodName == \"\(food_name)\"")
        
        var kcal = 0
        
        itemTable?.read(with: predicate) { (result, error) in
            if let err = error {
                print("ERROR ", err)
                completion(kcal)
            } else if let items = result?.items {
                for item in items {
                    print("Todo Item: ", item["kcal"]!)
                    kcal = item["kcal"] as! Int
                    completion(kcal)
                }
            }
        }
        
    }
    
}
