//
//  MovieQuizViewProtocol.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 31. 10. 2025..
//

import Foundation

protocol MovieQuizViewProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showNetworkError(message: String)
    func showFinalResults(message: String)
    func showActivityIndicator()
    func hideActivityIndicator()
    func highlightImageBorder(isCorrectAnswer: Bool)
    func resetImageBorder()
    func answerButtons(isEnabled: Bool)
}
