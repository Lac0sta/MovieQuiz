//
//  MovieQuizPresenting.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 13. 11. 2025..
//

import Foundation

protocol MovieQuizPresenting: AnyObject {
    var view: MovieQuizViewProtocol? { get set }
    func showAlert(model: AlertModel)
    func noButtonTapped()
    func yesButtonTapped()
    func restartQuiz()
    func viewDidLoad()
}
