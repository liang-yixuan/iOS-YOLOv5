//
//  MainViewController.swift
//  RUOK
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
    var requestHandler = RequestHandler()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
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
            requestHandler.imageRequest(image : pickedImage.upOrientationImage()!.resizeWithPercent(percentage: 0.5)!)
//            requestHandler.textRequest(image : pickedImage.upOrientationImage()!.resizeWithPercent(percentage: 0.5)!)
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


}

extension UIImage {
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


