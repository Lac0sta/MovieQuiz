//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 31. 10. 2025..
//

import UIKit

final class MovieQuizPresenter: QuestionGeneratorDelegate {
    
    private var currentQuestionIndex = 0
    var alertPresenter: AlertPresenter
    private var questionGenerator: QuestionGeneratorProtocol?
    private var currentQuestion: QuizQuestion?
    var correctAnswersCount = 0
    let questionsAmount = Constants.questionsAmount
    weak var view: MovieQuizViewController?
    
    init(
        view: MovieQuizViewController,
        moviesLoader: MoviesLoadingProtocol = MoviesLoader(),
        alertPresenter: AlertPresenter
    ) {
        self.view = view
        self.alertPresenter = alertPresenter
        self.questionGenerator = QuestionGenerator(
            moviesLoader: moviesLoader,
            delegate: self
        )
        
        questionGenerator?.loadData()
        view.showActivityIndicator()
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    func updateScore(isCorrect: Bool) {
        if isCorrect {
            correctAnswersCount += 1
        }
    }
    
    func restartQuiz() {
        resetQuestionIndex()
        correctAnswersCount = 0
        questionGenerator?.requestNextQuestion()
    }
    
    func yesButtonTapped() {
        processAnswer(isYes: true)
    }
    
    func noButtonTapped() {
        processAnswer(isYes: false)
    }
    
    func proceedToNextQuestionOrResults() {
        if isLastQuestion() {
            view?.statisticsService.store(correct: correctAnswersCount, total: questionsAmount)
            let resultMessage = view?.makeQuizResultsSummary() ?? ""
            view?.showFinalResults(message: resultMessage)
        } else {
            switchToNextQuestion()
            questionGenerator?.requestNextQuestion()
        }
    }
    
    // MARK: - QuestionGeneratorDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view?.show(quiz: viewModel)
            self.view?.answerButtons(isEnabled: true)
        }
    }
    
    func didLoadDataFromServer() {
        view?.hideActivityIndicator()
        questionGenerator?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        view?.showNetworkError(message: message)
    }
    
    // MARK: - Private Methods
    private func processAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        
        let givenAnswer = isYes
        let correctAnswer = currentQuestion.correctAnswer
        
        handleAnswer(isCorrect: givenAnswer == correctAnswer)
    }
    
    private func handleAnswer(isCorrect: Bool) {
        updateScore(isCorrect: isCorrect)
        view?.highlightImageBorder(isCorrectAnswer: isCorrect)
        view?.answerButtons(isEnabled: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.timeoutForAnswer) { [weak self] in
            guard let self = self else { return }
            self.view?.resetImageBorder()
            self.proceedToNextQuestionOrResults()
        }
    }
}
