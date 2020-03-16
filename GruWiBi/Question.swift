//
//  Question.swift
//  GruWiBi
//
//  Created by Felix Leitenberger on 12.03.20.
//  Copyright © 2020 Felix Leitenberger. All rights reserved.
//

import Foundation

struct Question: Codable {
    let question: String
    let correctAnswer: String
    let wrongAnswer1: String
    let wrongAnswer2: String
    let wrongAnswer3: String
    let imageQuestion: String?
    
    /// Loads the json from Bundle and returns an Array of Question objects
    
    static func get(for grade: String) -> [Question] {
        var questionList = [Question]()
        if let url = Bundle.main.url(forResource: "\(grade)questions", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: url)
                let jsonDecoder = JSONDecoder()
                questionList = try jsonDecoder.decode([Question].self, from: jsonData)
            } catch {
                fatalError()
            }
        }
        return questionList
    }
}


