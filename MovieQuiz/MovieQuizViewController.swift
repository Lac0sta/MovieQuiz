//
//  MovieQuizViewController.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 17. 10. 2025..
//

import UIKit

final class MovieQuizViewController: UIViewController {
    
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
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.ypWhite.cgColor
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "Placeholder")
        return imageView
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .ysDisplayBold23
        label.textColor = .ypWhite
        label.text = L10n.questionText
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
        return button
    }()
    
    private let yesButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.buttonYes, for: .normal)
        button.titleLabel?.font = .ysDisplayMedium20
        button.backgroundColor = .ypWhite
        button.setTitleColor(.ypBlack, for: .normal)
        button.layer.cornerRadius = 15
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
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 20
        return stackView
    }()
    
    // MARK: - Private Properties
    private var currentQuestionIndex = 0
    private var correctAnswersCount = 0
    
    // MARK: - Mock data
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Is the rating of this movie greater than 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Is the rating of this movie greater than 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            image: "Kill Bill",
            text: "Is the rating of this movie greater than 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            image: "The Avengers",
            text: "Is the rating of this movie greater than 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            image: "Deadpool",
            text: "Is the rating of this movie greater than 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            image: "The Green Knight",
            text: "Is the rating of this movie greater than 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            image: "Old",
            text: "Is the rating of this movie greater than 6?",
            correctAnswer: false
        ),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Is the rating of this movie greater than 6?",
            correctAnswer: false
        ),
        QuizQuestion(
            image: "Tesla",
            text: "Is the rating of this movie greater than 6?",
            correctAnswer: false
        ),
        QuizQuestion(
            image: "Vivarium",
            text: "Is the rating of this movie greater than 6?",
            correctAnswer: false
        ),
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBackground
        
        setupLabelsStackView()
        setupButtonsStackView()
        setupContentStackView()
        setupUI()
        
        let currentQuestion = questions[currentQuestionIndex]
        let viewModel = convert(model: currentQuestion)
        show(quiz: viewModel)
    }
    
    // MARK: - Private Methods
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionLabel.text = step.question
        questionNumberLabel.text = step.questionNumber
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
        view.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            contentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
