//
//  MovieQuizViewController.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 17. 10. 2025..
//

import UIKit

final class MovieQuizViewController: UIViewController, QuestionGeneratorDelegate {
    
    // MARK: - UI Elements
    private let questionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .ysDisplayMedium20
        label.textColor = .ypWhite
        label.text = L10n.questionTitle
        return label
    }()
    
    private let questionNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .ysDisplayMedium20
        label.textColor = .ypWhite
        label.text = "1/10"
        return label
    }()
    
    private let labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "Placeholder")
        return imageView
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .ysDisplayBold23
        label.textColor = .ypWhite
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let noButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.buttonNo, for: .normal)
        button.titleLabel?.font = .ysDisplayMedium20
        button.backgroundColor = .ypWhite
        button.setTitleColor(.ypBlack, for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let yesButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.buttonYes, for: .normal)
        button.titleLabel?.font = .ysDisplayMedium20
        button.backgroundColor = .ypWhite
        button.setTitleColor(.ypBlack, for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.isHidden = true
        return indicator
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 20
        return stackView
    }()
    
    // MARK: - Private Properties
    private var questionGenerator: QuestionGeneratorProtocol?
    private var currentQuestion: QuizQuestion?
    private lazy var alertPresenter = AlertPresenter(viewController: self)
    private var statisticsService: StatisticsServiceProtocol = StatisticsService()
    private var currentQuestionIndex = 0
    private var correctAnswersCount = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBackground
        
        setupLabelsStackView()
        setupButtonsStackView()
        setupContentStackView()
        setupUI()
        
        let questionGenerator = QuestionGenerator(moviesLoader: MoviesLoader(), delegate: self)
        self.questionGenerator = questionGenerator
        
        showActivityIndicator()
        questionGenerator.loadData()
    }
    
    // MARK: - Private Methods
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(Constants.questionsAmount)"
        )
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionLabel.text = step.question
        questionNumberLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        answerButtons(isLocked: false)
        imageView.layer.borderWidth = 8
        
        if isCorrect {
            correctAnswersCount += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.timeoutForAnswer) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        answerButtons(isLocked: true)
        imageView.layer.borderWidth = 0
        
        if currentQuestionIndex == Constants.questionsAmount - 1 {
            statisticsService.store(correct: correctAnswersCount, total: Constants.questionsAmount)
            
            let alertModel = AlertModel(
                title: L10n.resultTitle,
                text: """
                \(L10n.resultText): \(correctAnswersCount)/\(Constants.questionsAmount)
                \(L10n.resultTotal): \(statisticsService.gamesCount)
                \(L10n.resultRecord): \(statisticsService.bestGame.correct)/\(Constants.questionsAmount) (\(statisticsService.bestGame.date.dateTimeString))
                \(L10n.resultAccuracy): \(String(format: "%.2f", statisticsService.totalAccuracy))%
                """,
                buttonText: L10n.restartButton
            ) { [weak self] in
                self?.restartQuiz()
            }
            
            alertPresenter.showAlert(model: alertModel)
        } else {
            currentQuestionIndex += 1
            questionGenerator?.requestNextQuestion()
        }
    }
    
    private func answerButtons(isLocked: Bool) {
        noButton.isEnabled = isLocked
        yesButton.isEnabled = isLocked
    }
    
    private func restartQuiz() {
        currentQuestionIndex = 0
        correctAnswersCount = 0
        questionGenerator?.requestNextQuestion()
    }
    
    private func showActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    private func showNetworkError(message: String) {
        hideActivityIndicator()
        
        let alertModel = AlertModel(
            title: L10n.errorTitle,
            text: "\(L10n.errorMessage):\n\(message)",
            buttonText: L10n.restartButton
        ) { [weak self] in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswersCount = 0
            self.questionGenerator?.requestNextQuestion()
        }
        
        alertPresenter.showAlert(model: alertModel)
    }
    
    @objc private func noButtonTapped() {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = currentQuestion.correctAnswer
        
        showAnswerResult(isCorrect: givenAnswer == false)
    }
    
    @objc private func yesButtonTapped() {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = currentQuestion.correctAnswer
        
        showAnswerResult(isCorrect: givenAnswer == true)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        hideActivityIndicator()
        questionGenerator?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: - Setup Methods
    private func setupLabelsStackView() {
        [questionTitleLabel, questionNumberLabel].forEach {
            labelsStackView.addArrangedSubview($0)
        }
        
        questionNumberLabel.setContentHuggingPriority(UILayoutPriority(252), for: .horizontal)
        questionTitleLabel.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
    }
    
    private func setupButtonsStackView() {
        [noButton, yesButton].forEach {
            buttonsStackView.addArrangedSubview($0)
        }
    }
    
    private func setupContentStackView() {
        [labelsStackView, imageView, questionLabel, buttonsStackView].forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        buttonsStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let aspectRatio = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 3.0 / 2.0)
        aspectRatio.priority = .defaultLow
        aspectRatio.isActive = true
        
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
    
    private func setupUI() {
        [contentStackView, activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            contentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
