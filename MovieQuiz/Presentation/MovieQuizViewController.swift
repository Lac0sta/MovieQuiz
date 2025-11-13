//
//  MovieQuizViewController.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 17. 10. 2025..
//

import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewProtocol {
    
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
    private var presenter: MovieQuizPresenter!
    var statisticsService: StatisticsServiceProtocol = StatisticsService()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(
            view: self,
            moviesLoader: MoviesLoader(),
            alertPresenter: AlertPresenter(viewController: self)
        )
        
        view.backgroundColor = .ypBackground
        
        setupLabelsStackView()
        setupButtonsStackView()
        setupContentStackView()
        setupUI()
    }
    
    // MARK: - Private Methods
    @objc private func noButtonTapped() {
        presenter.noButtonTapped()
    }
    
    @objc private func yesButtonTapped() {
        presenter.yesButtonTapped()
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionLabel.text = step.question
        questionNumberLabel.text = step.questionNumber
    }
    
    func answerButtons(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    func showActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func resetImageBorder() {
        imageView.layer.borderWidth = 0
    }
    
    func makeQuizResultsSummary() -> String {
        let bestGame = statisticsService.bestGame
        
        let currentGameResultLine = "\(L10n.resultText): \(presenter.correctAnswersCount)/\(presenter.questionsAmount)"
        let totalGamesPlayedLine = "\(L10n.resultTotal): \(statisticsService.gamesCount)"
        let bestGameLine = "\(L10n.resultRecord): \(bestGame.correct)/\(presenter.questionsAmount) (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "\(L10n.resultAccuracy): \(String(format: "%.2f", statisticsService.totalAccuracy))%"
        
        let resultMessage = [
            currentGameResultLine, totalGamesPlayedLine, bestGameLine, averageAccuracyLine
        ].joined(separator: "\n")
        
        return resultMessage
    }
    
    func showNetworkError(message: String) {
        hideActivityIndicator()
        
        let alertModel = AlertModel(
            title: L10n.errorTitle,
            text: "\(L10n.errorMessage):\n\(message)",
            buttonText: L10n.restartButton
        ) { [weak self] in
            guard let self = self else { return }
            
            self.presenter.restartQuiz()
        }
        
        presenter.alertPresenter.showAlert(model: alertModel)
    }
    
    func showFinalResults(message: String) {
        let alertModel = AlertModel(
            title: L10n.resultTitle,
            text: message,
            buttonText: L10n.restartButton
        ) { [weak self] in
            guard let self = self else { return }
            self.presenter.restartQuiz()
        }
        
        presenter.alertPresenter.showAlert(model: alertModel)
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
