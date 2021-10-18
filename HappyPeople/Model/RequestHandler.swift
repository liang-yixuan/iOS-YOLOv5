//
//  RequestHandler.swift
//  HAPPYPEOPLE
//
//  Created by SHORT on 31/8/21.
//
// The RequestHandler is to send out 2 POST requests from the application to the server.
// CALL: Once a new image is upload from the device.
// RETURN: It will pass-on the returned the image to the ResultViewController and the data (JSON) to the ResultProcessor.

import UIKit

struct RequestHandler {
    let IPAddress : String
    
    // Send out two POST request for each image
    func imageRequest(image : UIImage) {
        let imageRequest: URLRequest
        let boundary: String

        do {
            (imageRequest, boundary) = try createImageRequest(route: "/", image: image)
        } catch {
            print(error)
            return
        }
        print(boundary)
        
        //  Send Request 1
        let task = URLSession.shared.dataTask(with: imageRequest) {data, response, error in
            if let data = data {
                if let image = UIImage(data: data) {
                     DispatchQueue.main.async {
                        NotificationCenter.default.post(name: Notification.Name("img"), object: image)
                        print("Returned Image")
                        
                        let textRequest: URLRequest
                        do {
                            textRequest = try createTextRequest(route: "/detections", boundary: boundary)
                        } catch {
                            print(error)
                            return
                        }
                        //  Send Request 2
                        let textTask = URLSession.shared.dataTask(with: textRequest) {data, response, error in
                            if let data = data {
                                DispatchQueue.main.async {
                                    NotificationCenter.default.post(name: Notification.Name("text"), object: data)
                                    print("Returned Text")
                                }
                                
                            } else if let error = error {
                                print("HTTP Request Failed \(error)")
                            }
                        }
                        textTask.resume()
                     }
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
    
    // Compose the first request (sending: image, receiving: image)
    func createImageRequest(route: String, image: UIImage) throws -> (URLRequest, String) {

        let boundary = generateBoundaryString()
        let url = URL(string: IPAddress + route)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = try createImageBody(boundary: boundary, image: image)
        return (request, boundary)
    }

    // Create the request body for the first image request
    private func createImageBody(boundary: String, image: UIImage) throws -> Data {
        var body = Data()
            let data = Data((image.pngData())!)
            let mimetype = "image/*"

            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(boundary).jpeg\"\r\n")
            body.append("Content-Type: \(mimetype)\r\n\r\n")
            body.append(data)
            body.append("\r\n")

        body.append("--\(boundary)--\r\n")
        return body
    }
    
    // Generate an unique name for each image before sending
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    // Compose the second request (sending: image name, receiving: JSON result)
    func createTextRequest(route: String, boundary: String) throws -> URLRequest{

        let url = URL(string: IPAddress + route)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["content-type": "text/plain"]
        request.httpBody = boundary.data(using: .utf8)
        return request
    }
}

// Extend to append property to the Data type
extension Data {
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
