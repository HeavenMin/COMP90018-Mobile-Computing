//
//  ViewController.swift
//  KeepFit
//
//  Created by Min Gao on 2017/9/29.
//  Copyright © 2017年 Min Gao. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var photoScene: UIImageView!
    @IBOutlet weak var prediction: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init image in screen
        guard let image = UIImage(named: "banana") else {
            fatalError("no starting image")
        }
        photoScene.image = image
        guard let ciImage = CIImage(image: image) else {
            fatalError("couldn't convert UIImage to CIImage")
        }
        detectScene(image: ciImage)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController {
    
    @IBAction func getImage(_ sender: Any) {
//        let pickerController = UIImagePickerController()
//        pickerController.delegate = self
//        pickerController.sourceType = .savedPhotosAlbum
//        present(pickerController, animated: true)
        chooseImageSheet()
    }
    
    func chooseImageSheet() {
        let actionSheet = UIAlertController(title: "PHOTO SOURCE", message: nil, preferredStyle: .actionSheet)
        
        //photo source - camera
        actionSheet.addAction(UIAlertAction(title: "CAMERA", style: .default, handler: { alertAction in
            self.showImagePickerForSourceType(.camera)
        }))
        
        //photo source - photo library
        actionSheet.addAction(UIAlertAction(title: "PHOTO LIBRARY", style: .default, handler: { alertAction in
            self.showImagePickerForSourceType(.photoLibrary)
        }))
        
        //cancel button
        actionSheet.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler:nil))
        
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    func showImagePickerForSourceType(_ sourceType: UIImagePickerControllerSourceType) {
        
        DispatchQueue.main.async(execute: {
            let imagePickerController = UIImagePickerController()
            imagePickerController.allowsEditing = true
            imagePickerController.modalPresentationStyle = .currentContext
            imagePickerController.sourceType = sourceType
            ////////////////////////////////////////
            /*
             We actually have two delegates:UIImagePickerControllerDelegate and UINavigationControllerDelegate. The UINavigationControllerDelegate is required but we do nothing with it.
             Add the following:
             */
            imagePickerController.delegate = self
            
            self.present(imagePickerController, animated: true, completion: nil)
        })
        
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {

            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                self.photoScene.image = image
                self.photoScene.contentMode = .scaleAspectFit
                guard let ciImage = CIImage(image: image) else {
                    fatalError("couldn't convert UIImage to CIImage")
                }
                self.detectScene(image: ciImage)
            }
        }
    }
}

extension ViewController: UINavigationControllerDelegate {
}

extension ViewController {
    
    func detectScene(image: CIImage) {
        prediction.text = "detecting scene..."
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("can't load Places ML model")
        }
        
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first else {
                    fatalError("unexpected result type from VNCoreMLRequest")
            }
            
//            let article = (self?.vowels.contains(topResult.identifier.first!))! ? "an" : "a"
            DispatchQueue.main.async { [weak self] in
                self?.prediction.text = "\(Int(topResult.confidence * 100))% it's \(topResult.identifier)"
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

