//
//  QuestionGeneratorProtocol.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 24. 10. 2025..
//

import Foundation

protocol QuestionGeneratorProtocol {
    var delegate: QuestionGeneratorDelegate? { get set }
    func loadData()
    func requestNextQuestion()
}
