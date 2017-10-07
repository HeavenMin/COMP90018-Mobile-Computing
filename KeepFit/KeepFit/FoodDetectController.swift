//
//  FoodDetectController.swift
//  KeepFit
//
//  Created by Min Gao on 2017/8/29.
//  Copyright © 2017年 Min Gao. All rights reserved.
//

import UIKit
//IOS foundational machine learning framework
import CoreML
import Vision

class FoodDetectController: UIViewController {
    
    //The food photo need to be recognized
    @IBOutlet weak var photoScene: UIImageView!
    //The prediciton label
    @IBOutlet weak var prediction: UILabel!
    @IBOutlet weak var foodInformation: UITextView!
    @IBOutlet weak var recommend_sign: UIImageView!
    @IBOutlet weak var addfood_button: UIButton!
    @IBOutlet weak var addeat_button: UIButton!
    
    var canUpdateFoodInfo: Bool = false
    var foodKcal: Int?
    
    let vowels: [Character] = ["a", "e", "i", "o", "u"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //switch view with gestures
        let left = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        left.direction = .left
        self.view.addGestureRecognizer(left)
        let right = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        right.direction = .right
        self.view.addGestureRecognizer(right)
        
        //init image in screen
        guard let image = UIImage(named: "scene") else {
            fatalError("No starting image")
        }
        photoScene.image = image
        //CIImage using for COreML, no need to predict when start this view
//        guard let ciImage = CIImage(image: image) else {
//            fatalError("Couldn't convert UIImage to CIImage")
//        }
//        detectScene(image: ciImage)
        prediction.text = "Prediction"
        foodInformation.text = "Please choose a food you want to recognize form Photo Library or take a picture from your Camera."
        addfood_button.isEnabled = false
        addeat_button.isEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //init image in screen
//        guard let image = UIImage(named: "scene") else {
//            fatalError("No starting image")
//        }
//        photoScene.image = image
//        prediction.text = "Prediction"
//        foodInformation.text = "Please choose a food you want to recognize form Photo Library or take a picture from your Camera."
//        recommend_sign.image = nil
//        canUpdateFoodInfo = false
//        addfood_button.isEnabled = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //switch view with gestures
    @objc func swipeLeft() {
        let total = self.tabBarController!.viewControllers!.count - 1
        tabBarController!.selectedIndex = min(total, tabBarController!.selectedIndex + 1)
    }
    @objc func swipeRight() {
        tabBarController!.selectedIndex = max(0, tabBarController!.selectedIndex - 1)
    }
    
}

//button part
extension FoodDetectController {
    
    //old function for chooes the ImageSheet by one button
    @IBAction func getImage(_ sender: Any) {
        
        chooseImageSheet()
        
        // old method
        //        let pickerController = UIImagePickerController()
        //        pickerController.delegate = self
        //        pickerController.sourceType = .savedPhotosAlbum
        //        present(pickerController, animated: true)
        
    }
    
    //old function for chooes the ImageSheet by one button
    func chooseImageSheet() {
        
        let actionSheet = UIAlertController(title: "From", message: nil, preferredStyle: .actionSheet)
        //from camera
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { alertAction in
            self.showImagePickerForSourceType(.camera)
        }))
        //from photo library
        actionSheet.addAction(UIAlertAction(title: "Photo Lib", style: .default, handler: { alertAction in
            self.showImagePickerForSourceType(.photoLibrary)
        }))
        //for cancel
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    //button for get image from camera
    @IBAction func getImageFromCamera(_ sender: Any) {
        self.showImagePickerForSourceType(.camera)
    }
    
    //button for get image from photo library
    @IBAction func getImageFromPhotoLibrary(_ sender: Any) {
        self.showImagePickerForSourceType(.photoLibrary)
    }
    
    func showImagePickerForSourceType(_ sourceType: UIImagePickerControllerSourceType) {
        
        DispatchQueue.main.async(execute: {
            let imagePickerController = UIImagePickerController()
            // allows for editing
            imagePickerController.allowsEditing = true
            imagePickerController.modalPresentationStyle = .currentContext
            imagePickerController.sourceType = sourceType
            imagePickerController.delegate = self
            
            self.present(imagePickerController, animated: true, completion: nil)
        })
        
    }
    
    //for admin to update foodInfo, insert the calorie info to the azure database server
    @IBAction func addFoodInfo_admin(_ sender: Any) {
        var kcalTextField: UITextField?
        
        let alertController = UIAlertController(
            title: "Food Info",
            message: "Please enter the kcal of the \(prediction.text!).",
            preferredStyle: UIAlertControllerStyle.alert)
        
        let insertFoodInfoAction = UIAlertAction(
            title: "OK", style: UIAlertActionStyle.default) {
            (action) -> Void in
            
            if let kcal = kcalTextField?.text {
                print("kcal = \(kcal)")
                if (kcal != "") {
//                    FoodDatabaseAzureOperation().insert(food_name: self.prediction.text!, kcal: Int(kcal)!)
                    
                    FoodDatabaseAzureOperation().insertKcal(food_name: self.prediction.text!, kcal: Int(kcal)!){(success: Bool) -> Void in
                        if (success) {
                            self.foodInformation.text = "Uploading Calorie infomation of \(self.prediction.text!) succeeded."
                        } else {
                            self.foodInformation.text = "Uploading calorie infomation of \(self.prediction.text!) failed, please try again."
                        }
                        
                    }
                } else {
                    print("can not insert info without a number.")
                }
            } else {
                print("No calorie infomation entered.")
            }
        }
        
        let cancelAction = UIAlertAction(
            title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        let warnController = UIAlertController(
            title: "Warning",
            message: "Only a food without calorie infomation can be added to the database.",
            preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(
            title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertController.addTextField {
            (kcal_txt) -> Void in
            kcalTextField = kcal_txt
            kcalTextField!.placeholder = "enter kcal here"
            kcalTextField?.keyboardType = UIKeyboardType.numberPad
        }
        
        if (self.prediction.text == "Prediction") {
            print("Can not open alertController without a prediciton.")
            foodInformation.text = "Before you help to add the food calorie infomation, please choose a food you want to recognize form Photo Library or take a picture from your Camera. Only a food without calorie infomation can be added to the database."
        } else if (self.canUpdateFoodInfo == false) {
            print("Can not open alertController without a prediciton.")
//            foodInformation.text = "Only a food without calorie infomation can be added to the database."
            warnController.addAction(okAction)
            self.present(warnController, animated: true, completion: nil)
        } else {
            alertController.addAction(insertFoodInfoAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func add_eat_info(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Eat Info",
            message: "Did you eat the food?",
            preferredStyle: UIAlertControllerStyle.alert)
        
        let insertEatInfoAction = UIAlertAction(
        title: "OK", style: UIAlertActionStyle.default) {
            (action) -> Void in
            AzureOperation().insertFoodRecord(food_name:self.prediction.text!, calorie:Double(self.foodKcal!))
            self.addeat_button.isEnabled = false
        }
        
        let cancelAction = UIAlertAction(
            title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertController.addAction(insertEatInfoAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //jump to the scale view {Fade Push Reveal MoveIn}
    @IBAction func gotoScaleView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let scaleView = storyboard.instantiateViewController(withIdentifier: "scale") as UIViewController
        
//        let transition = CATransition()
//        transition.duration = 0.2
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromBottom
//        view.window!.layer.add(transition, forKey: kCATransition)
//        self.present(scaleView, animated: false, completion: nil)
        
        self.present(scaleView, animated: true, completion: nil)
    }
    
}

//image picker part
extension FoodDetectController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {
            
            //after select the image, disable the update button first.
            self.canUpdateFoodInfo = false
            self.addfood_button.isEnabled = false
            self.addeat_button.isEnabled = false
            
            //if image was taked from camera, save it to photo album
            if (picker.sourceType == .camera) {
                if let origImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    UIImageWriteToSavedPhotosAlbum(origImage, nil, nil, nil)
                }
            }
            
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                self.photoScene.image = image
                //get fit scene image
                self.photoScene.contentMode = .scaleAspectFit
                //transfer UIImage to CIImage
                guard let ciImage = CIImage(image: image) else {
                    fatalError("couldn't convert UIImage to CIImage")
                }
                //make prediction for the food
                self.detectScene(image: ciImage)
            }
        }
    }
}

extension FoodDetectController: UINavigationControllerDelegate {
}

//food prediction part
extension FoodDetectController {
    
    //funciton for make the detection
    func detectScene(image: CIImage) {
        
        prediction.text = "Detecting..."
        foodInformation.text = "Loading your food information from the food database..."
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Can't load the ML model.")
        }
        
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first else {
                    fatalError("Unexpected result type from VNCoreMLRequest.")
            }
            
            //Originally used to distinguish vowel sounds
            DispatchQueue.main.async { [weak self] in
                //get the first predict result in the top result
                self?.prediction.text = "\(topResult.identifier.components(separatedBy: ",")[0])"
                let an_or_a = (self?.vowels.contains(topResult.identifier.first!))! ? "an" : "a"
                
//                self?.foodInformation.text = "\(Int(topResult.confidence * 100))% it's \(topResult.identifier), the calorie of this food is \(FoodDatabaseAzureOperation().queryForCal(food_name: topResult.identifier.components(separatedBy: ",")[0]))"
                FoodDatabaseAzureOperation().queryForKcal(food_name: topResult.identifier.components(separatedBy: ",")[0]){(kcal: Int) -> Void in
                    // Int(topResult.confidence * 100) to show the confidence, not in use now.
                    self?.foodKcal = kcal
                    var advice: String
                    if (kcal <= 350 && kcal >= 0) {
                        advice = "Recommand to eat."
                        self?.recommend_sign.frame = CGRect(x: 289, y: 64, width: 70, height: 80)
                        self?.recommend_sign.image = UIImage(named: "recommand_new")
                    } else if (kcal > 350) {
                        advice = "Not recommand to eat a lot."
                        self?.recommend_sign.frame = CGRect(x: 289, y: 64, width: 70, height: 56)
                        self?.recommend_sign.image = UIImage(named: "not_recommand_new")
                    } else {
                        advice = ""
                        self?.recommend_sign.image = nil
                    }
                    if (kcal != -1) {
                        self?.foodInformation.text = "It's \(an_or_a) \(topResult.identifier.components(separatedBy: ",")[0]). The calorie of this food is \(kcal) kcal.\n\(advice)"
                        if (((UIApplication.shared.delegate) as! AppDelegate).userName != nil) {
                            self?.addeat_button.isEnabled = true
                        }
                    } else {
                        self?.foodInformation.text = "It's not a food, or its data is not included. If you want to help us improve the database. Please click the button (+) to help us."
                        self?.canUpdateFoodInfo = true
                        self?.addfood_button.isEnabled = true
                    }
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
        
    }
}
