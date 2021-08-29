//
//  ModelManager.swift
//  RUOK
//
//  Created by SHORT on 29/8/21.
//

import Foundation

struct ModelManager {
    let serverURL = "http://192.168.0.2:5000"
    
    func fetchResult(route: String) {
        let url = "\(serverURL)\(route)"
        performRequest(urlString: url)
    }
    
    func performRequest(urlString : String) {
        if let url = URL(string: urlString) {
//            let session = URLSession(configuration: .default)
            let getTask = URLSession.shared.dataTask(with: url, completionHandler: handle(data:response:error:))
            getTask.resume()
            
            
            
        }
    }
    
    func handle(data : Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString!)
        }
    }
}
