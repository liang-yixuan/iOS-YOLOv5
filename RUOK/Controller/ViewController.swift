//
//  ViewController.swift
//  RUOK
//
//  Created by SHORT on 24/8/21.
//

import UIKit
import CoreML
import Vision
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker1 = UIImagePickerController()
    let imagePicker2 = UIImagePickerController()
    
    var requestHandler = RequestHandler()
    
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
//            imageView.image = pickedImage
            imageRequest(image : pickedImage.upOrientationImage()!.resizeWithPercent(percentage: 0.5)!)
        }
        
        imagePicker1.dismiss(animated: true, completion: nil)
        imagePicker2.dismiss(animated: true, completion: nil)
    }
    
    func imageRequest(image : UIImage) {
        let request: URLRequest

        do {
            request = try requestHandler.createRequest(route: "/", image: image)
        } catch {
            print(error)
            return
        }

        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                if let image = UIImage(data: data) {
                     DispatchQueue.main.async {
                        self.imageView.image = image
                     }
                    
                    print("returned image")
                } else {
                    let dataString = String(data: data, encoding: .utf8)
                    print("return data:\(String(describing: dataString))")
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }

        }
        task.resume()
    }
    
    
    @IBAction func submitButtonClick(_ sender: UIButton) {
//        redirect to result view
//        send image and request to server
//        modelManager.fetchResult(route: "/dummy")
//        modelManager.requestImageTask()
        
    }
    



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
}

extension UIImage {
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
