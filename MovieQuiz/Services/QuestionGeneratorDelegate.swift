//
//  QuestionGeneratorDelegate.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 24. 10. 2025..
//

import Foundation

protocol QuestionGeneratorDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
