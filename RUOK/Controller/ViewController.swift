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
    
    var modelManager = ModelManager()
    
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
        }
        
        imagePicker1.dismiss(animated: true, completion: nil)
        imagePicker2.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonClick(_ sender: UIButton) {
//        redirect to result view
//        send image and request to server
//        modelManager.fetchResult(route: "/dummy")
        
//        let imageData: Data = imageView.image!.jpegData(compressionQuality: 0.0)!
//        let imageStr: String = imageData.base64EncodedString()
//        let urlString: String = "imageStr=" + imageStr
//
//        var request: URLRequest = URLRequest(url: URL(string: "http://192.168.0.2:5000/")!)
//        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//        request.httpBody = urlString.data(using: .utf8)
//
//        let session = URLSession(configuration: .default)
//        let task = session.dataTask(with: request) { (data, response, error) in
//            if let data = data {
//                if let image = UIImage(data: data) {
//                    self.imageView.image = image
//                    print("returned image")
//                } else {
//                    let dataString = String(data: data, encoding: .utf8)
//                    print("return data:\(String(describing: dataString))")
//                }
//            } else if let error = error {
//                print("HTTP Request Failed \(error)")
//            }
//
//        }
//        task.resume()
        
        let request: URLRequest

        do {
            request = try createRequest()
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

            // parse `data` here, then parse it

            // note, if you want to update the UI, make sure to dispatch that to the main queue, e.g.:
            //
            // DispatchQueue.main.async {
            //     // update your UI and model objects here
            // }
        }
        task.resume()
    }
    
    /// Create request
    ///
    /// - parameter userid:   The userid to be passed to web service
    /// - parameter password: The password to be passed to web service
    /// - parameter email:    The email address to be passed to web service
    ///
    /// - returns:            The `URLRequest` that was created
    func createRequest() throws -> URLRequest {

        let boundary = generateBoundaryString()

        let url = URL(string: "http://192.168.0.2:5000/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let fileURL = Bundle.main.url(forResource: "Happy_People", withExtension: "jpeg")!
        request.httpBody = try createBody(filePathKey: "file", urls: [fileURL], boundary: boundary)

        return request
    }

    /// Create body of the `multipart/form-data` request
    ///
    /// - parameter parameters:   The optional dictionary containing keys and values to be passed to web service.
    /// - parameter filePathKey:  The optional field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
    /// - parameter urls:         The optional array of file URLs of the files to be uploaded.
    /// - parameter boundary:     The `multipart/form-data` boundary.
    ///
    /// - returns:                The `Data` of the body of the request.

    private func createBody(filePathKey: String, urls: [URL], boundary: String) throws -> Data {
        var body = Data()
        
        for url in urls {
            let filename = url.lastPathComponent
            let data = try Data(contentsOf: url)
            let mimetype = mimeType(for: filename)

            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
            body.append("Content-Type: \(mimetype)\r\n\r\n")
            body.append(data)
            body.append("\r\n")
        }

        body.append("--\(boundary)--\r\n")
        return body
    }

    /// Create boundary string for multipart/form-data request
    ///
    /// - returns:            The boundary string that consists of "Boundary-" followed by a UUID string.

    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }

    /// Determine mime type on the basis of extension of a file.
    ///
    /// This requires `import MobileCoreServices`.
    ///
    /// - parameter path:         The path of the file for which we are going to determine the mime type.
    ///
    /// - returns:                Returns the mime type if successful. Returns `application/octet-stream` if unable to determine mime type.

    private func mimeType(for path: String) -> String {
        let pathExtension = URL(fileURLWithPath: path).pathExtension as NSString

        guard
            let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, nil)?.takeRetainedValue(),
            let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue()
        else {
            return "application/octet-stream"
        }

        return mimetype as String
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

extension Data {

    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.

    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}


