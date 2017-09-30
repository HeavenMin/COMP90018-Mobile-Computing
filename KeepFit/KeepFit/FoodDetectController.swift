//
//  FoodDetectController.swift
//  KeepFit
//
//  Created by Min Gao on 2017/8/29.
//  Copyright © 2017年 Min Gao. All rights reserved.
//

import UIKit
//IOS machine learning framework
import CoreML
import Vision

class FoodDetectController: UIViewController {
    
    //The food photo need to be recognized
    @IBOutlet weak var photoScene: UIImageView!
    //The prediciton label
    @IBOutlet weak var prediction: UILabel!
    @IBOutlet weak var foodInformation: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //switch view with gestures
//        let left = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
//        left.direction = .left
//        self.view.addGestureRecognizer(left)
//
//        let right = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
//        right.direction = .right
//        self.view.addGestureRecognizer(right)
        
        //init image in screen
        guard let image = UIImage(named: "scene") else {
            fatalError("No starting image")
        }
        photoScene.image = image
        //CIImage using for COreML
//        guard let ciImage = CIImage(image: image) else {
//            fatalError("Couldn't convert UIImage to CIImage")
//        }
//        detectScene(image: ciImage)
        prediction.text = "Prediction"
        foodInformation.text = "Please choose a food you want to recognize form Photo Library or take a picture from your Camera."
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //init image in screen
        guard let image = UIImage(named: "scene") else {
            fatalError("No starting image")
        }
        photoScene.image = image
        prediction.text = "Prediction"
        foodInformation.text = "Please choose a food you want to recognize form Photo Library or take a picture from your Camera."
        
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

extension FoodDetectController {
    
    //old function for chooes the ImageSheet by one button
    @IBAction func getImage(_ sender: Any) {
        
        // old method
        //        let pickerController = UIImagePickerController()
        //        pickerController.delegate = self
        //        pickerController.sourceType = .savedPhotosAlbum
        //        present(pickerController, animated: true)
        chooseImageSheet()
        
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
    
    @IBAction func getImageFromCamera(_ sender: Any) {
        self.showImagePickerForSourceType(.camera)
    }
    
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
    
}

extension FoodDetectController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {
            
            if let origImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                UIImageWriteToSavedPhotosAlbum(origImage, nil, nil, nil)
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

extension FoodDetectController {
    
    //funciton for make the detection
    func detectScene(image: CIImage) {
        prediction.text = "Detecting..."
        foodInformation.text = "Loading your food information..."
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Can't load the ML model.")
        }
        
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first else {
                    fatalError("Unexpected result type from VNCoreMLRequest.")
            }
            
            //Originally used to distinguish vowel sounds
            //let article = (self?.vowels.contains(topResult.identifier.first!))! ? "an" : "a"
            DispatchQueue.main.async { [weak self] in
                //get the first predict result in the top result
                self?.prediction.text = "\(topResult.identifier.components(separatedBy: ",")[0])"
                self?.foodInformation.text = "\(Int(topResult.confidence * 100))% it's \(topResult.identifier)"
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