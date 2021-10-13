//
//  ResultProcessor.swift
//  HAPPYPEOPLE
//
//  Created by SHORT on 2/9/21.
//

import Foundation

struct ResultProcessor {
    func getPeople(result : Data) -> [Person] {
        var people : [Person] = []
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Result.self, from: result)
            for response in decodedData.response {
                let person = Person(id: String(response.object), age: (response.age_class_label ?? "Unknown")!, emotion: (response.emo_class_label ?? "Unknown")!, ethnicity: (response.ethnicity_class_label  ?? "Unknown")!, gender: (response.gender_class_label  ?? "Unknown")!)
                people.append(person)
            }
        } catch {
            print(error)
        }
        return people
    }
}

struct Person {
    let id : String
    let age : String
    let emotion : String
    let ethnicity : String
    let gender : String
}

struct Result : Decodable {
    let response : [Object]
}

struct Object : Decodable {
    let object : Int
    var age_class_label : String?
    var gender_class_label : String?
    var ethnicity_class_label : String?
    var emo_class_label : String?
}
