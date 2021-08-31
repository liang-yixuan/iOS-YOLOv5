//
//  RequestHandler.swift
//  RUOK
//
//  Created by SHORT on 31/8/21.
//

import UIKit

struct RequestHandler {
    func createRequest(route: String, image: UIImage) throws -> URLRequest {

        let boundary = generateBoundaryString()
        let url = URL(string: "http://192.168.0.2:5000" + route)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = try createBody(boundary: boundary, image: image)
        return request
    }


    private func createBody(boundary: String, image: UIImage) throws -> Data {
        var body = Data()

            let data = Data((image.pngData())!)
            let mimetype = "image/jpeg"
            print("mimetype", mimetype)

            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"userImg.jpeg\"\r\n")
            body.append("Content-Type: \(mimetype)\r\n\r\n")
            body.append(data)
            body.append("\r\n")

        body.append("--\(boundary)--\r\n")
        return body
    }
    
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }

}

extension Data {

    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
