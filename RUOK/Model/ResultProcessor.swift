//
//  ResultProcessor.swift
//  RUOK
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
                let person = Person(id: String(response.object), age: response.age_class_label, emotion: response.emo_class_label, ethnicity: response.ethnicity_class_label, gender: response.gender_class_label)
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
    let age_class_label : String
    let gender_class_label : String
    let ethnicity_class_label : String
    let emo_class_label : String
}
