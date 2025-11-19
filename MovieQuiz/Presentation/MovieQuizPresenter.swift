//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 31. 10. 2025..
//

import UIKit

final class MovieQuizPresenter: MovieQuizPresenting {
    
    private let alertPresenter: AlertPresentingProtocol
    private let questionGenerator: QuestionGeneratorProtocol
    private let statisticsService: StatisticsServiceProtocol
    private let questionsAmount: Int
    private(set) var correctAnswersCount = 0
    private var currentQuestionIndex = 0
    private var currentQuestion: QuizQuestion?
    
    weak var view: MovieQuizViewProtocol?
    
    init(
        alertPresenter: AlertPresentingProtocol,
        questionGenerator: QuestionGeneratorProtocol,
        statisticsService: StatisticsServiceProtocol,
        questionsAmount: Int = Constants.questionsAmount
    ) {
        self.alertPresenter = alertPresenter
        self.questionGenerator = questionGenerator
        self.statisticsService = statisticsService
        self.questionsAmount = questionsAmount
    }
    
    func viewDidLoad() {
        view?.showActivityIndicator()
        questionGenerator.loadData()
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
        questionGenerator.requestNextQuestion()
    }
    
    func yesButtonTapped() {
        processAnswer(isYes: true)
    }
    
    func noButtonTapped() {
        processAnswer(isYes: false)
    }
    
    func showAlert(model: AlertModel) {
        alertPresenter.showAlert(model: model)
    }
    
    // MARK: - Private Methods
    private func processAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        
        let givenAnswer = isYes
        let correctAnswer = currentQuestion.correctAnswer
        
        handleAnswer(isCorrect: givenAnswer == correctAnswer)
    }
    
    private func proceedToNextQuestionOrResults() {
        if isLastQuestion() {
            statisticsService.store(correct: correctAnswersCount, total: questionsAmount)
            let resultMessage = makeQuizResultsSummary()
            view?.showFinalResults(message: resultMessage)
        } else {
            switchToNextQuestion()
            questionGenerator.requestNextQuestion()
        }
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
    
    private func makeQuizResultsSummary() -> String {
        let bestGame = statisticsService.bestGame
        
        let currentGameResultLine = "\(L10n.resultText): \(correctAnswersCount)/\(questionsAmount)"
        let totalGamesPlayedLine = "\(L10n.resultTotal): \(statisticsService.gamesCount)"
        let bestGameLine = "\(L10n.resultRecord): \(bestGame.correct)/\(questionsAmount) (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "\(L10n.resultAccuracy): \(String(format: "%.2f", statisticsService.totalAccuracy))%"
        
        let resultMessage = [
            currentGameResultLine, totalGamesPlayedLine, bestGameLine, averageAccuracyLine
        ].joined(separator: "\n")
        
        return resultMessage
    }
}

// MARK: - QuestionGeneratorDelegate
extension MovieQuizPresenter: QuestionGeneratorDelegate {
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
        questionGenerator.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        view?.showNetworkError(message: message)
    }
}
