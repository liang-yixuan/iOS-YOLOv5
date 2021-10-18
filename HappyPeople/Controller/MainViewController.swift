//
//  MainViewController.swift
//  HAPPYPEOPLE
//
//  Created by SHORT on 24/8/21.
//

import UIKit
import CoreML
import Vision
import MobileCoreServices

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker1 = UIImagePickerController()
    let imagePicker2 = UIImagePickerController()
    var ssdRequestHandler = RequestHandler(IPAddress: "http://115.146.94.146:5004")
    var frcnnRequestHandler = RequestHandler(IPAddress: "http://115.146.94.146:5003")
    var yoloRequestHandler = RequestHandler(IPAddress: "http://115.146.94.146:5001")
    var model : String = "SSD"
    
    // Hide Naviagation Bar when loading
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    // Unhide Naviagation Bar when leaving
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // Set up 2 image pickers
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker1.delegate = self
        imagePicker1.sourceType = .camera
        imagePicker1.allowsEditing = false
        
        imagePicker2.delegate = self
        imagePicker2.sourceType = .photoLibrary
        imagePicker2.allowsEditing = false
    }
    
    // Call different RequestHandlers for different models
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            switch model {
            case "SSD" :
                ssdRequestHandler.imageRequest(image : pickedImage.upOrientationImage()!.resizeWithWidth(width: 300)!.removeAlpha())
            case "FRCNN":
                frcnnRequestHandler.imageRequest(image : pickedImage.upOrientationImage()!.resizeWithWidth(width: 300)!.removeAlpha())
            case "YOLO":
                yoloRequestHandler.imageRequest(image : pickedImage.upOrientationImage()!.resizeWithWidth(width: 300)!.removeAlpha())
            default:
                break
            }
        }
        
        picker.dismiss(animated: true) {
            self.performSegue(withIdentifier: "showResult", sender: self)}
    }

    @IBAction func takePhotoButtonClick(_ sender: UIButton) {
        present(imagePicker1, animated: true, completion: nil)
    }
    
    @IBAction func choosePhotoButtonClick(_ sender: UIButton) {
        present(imagePicker2, animated: true, completion: nil)
    }
    
    @IBAction func aboutButtonClick(_ sender: UIButton) {
    }


    @IBAction func modelChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            model = "SSD"
            print(model)
        case 1:
            model = "FRCNN"
            print(model)
        case 2:
            model = "YOLO"
            print(model)
        default:
            break
        }
    }
}

// Helper functions to adjust UIImage
extension UIImage {
    func removeAlpha() -> UIImage {
            let format = UIGraphicsImageRendererFormat.init()
            format.opaque = true //Removes Alpha Channel
            format.scale = self.scale //Keeps original image scale.
            let size = self.size
            return UIGraphicsImageRenderer(size: size, format: format).image { _ in
                self.draw(in: CGRect(origin: .zero, size: size))
            }
        }
    
    func upOrientationImage() -> UIImage? {
        switch imageOrientation {
        case .up:
            return self
        default:
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(in: CGRect(origin: .zero, size: size))
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result
        }
    }
    
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}


