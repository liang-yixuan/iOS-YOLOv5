//
//  ViewController.swift
//  RUOK
//
//  Created by SHORT on 24/8/21.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker1 = UIImagePickerController()
    let imagePicker2 = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker1.delegate = self
        imagePicker1.sourceType = .camera
        imagePicker1.allowsEditing = false
        
        imagePicker2.delegate = self
        imagePicker2.sourceType = .photoLibrary
        imagePicker2.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = pickedImage
            
//            guard let ciimage = CIImage(image: pickedImage) else {
//                fatalError("Could not convert to CI Image.")
//            }
//            detect(image: ciimage)
            
            
        }
        
        imagePicker1.dismiss(animated: true, completion: nil)
        imagePicker2.dismiss(animated: true, completion: nil)
    }
    
//    func detect(image: CIImage) {
//
//            // Load the ML model through its generated class
//        guard let model = try? VNCoreMLModel(for: yolov3(configuration: .init()).model) else {
//                fatalError("can't load ML model")
//            }
//
//            let request = VNCoreMLRequest(model: model) { request, error in
//                guard let results = request.results as? [VNCoreMLFeatureValueObservation]//,
////                    let topResult = results.first
//                    else {
//                        fatalError("unexpected result type from VNCoreMLRequest")
//                }
//                print(results)
//            }
//
//            let handler = VNImageRequestHandler(ciImage: image)
//
//            do {
//                try handler.perform([request])
//            }
//            catch {
//                print(error)
//            }
//        }
//

        
    
    @IBAction func takePhotoButtonClick(_ sender: UIButton) {
        present(imagePicker1, animated: true, completion: nil)
        print("take photo button clicked")
    }
    
    @IBAction func choosePhotoButtonClick(_ sender: UIButton) {
        present(imagePicker2, animated: true, completion: nil)
        print("choose photo button clicked")
    }
    
    @IBAction func aboutButtonClick(_ sender: UIButton) {
        print("about button clicked")
    }


}

