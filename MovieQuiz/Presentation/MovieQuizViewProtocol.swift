//
//  MovieQuizViewProtocol.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 31. 10. 2025..
//

import Foundation

protocol MovieQuizViewProtocol {
    func show(quiz step: QuizStepViewModel)
    func showNetworkError(message: String)
    func showActivityIndicator()
    func hideActivityIndicator()
    func answerButtons(isEnabled: Bool)
}
