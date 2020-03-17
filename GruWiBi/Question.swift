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
    
    private static func parseQuestionList(for grade: String) -> [Question] {
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
    
    /// Returns an array of 15 random questions for the selected grades
    
    static func getQuestionSet(for grades: String...) -> [Question] {
        var fullQuestionList = [Question]()
        var questionSet = [Question]()
        for grade in grades {
            fullQuestionList += parseQuestionList(for: grade)
        }
        for _ in 0...14 {
            let randomIndex = Int.random(in: 0..<(fullQuestionList.count))
            let randomQuestion = fullQuestionList.remove(at: randomIndex)
            questionSet.append(randomQuestion)
            questionSet.shuffle()
        }
        return questionSet
    }
}


