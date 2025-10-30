//
//  QuestionGenerator.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 24. 10. 2025..
//

import Foundation

final class QuestionGenerator: QuestionGeneratorProtocol {
    // MARK: - Private Properties
    private let moviesLoader: MoviesLoadingProtocol
    private var movies: [MostPopularMovie] = []
    
    // MARK: - Delegate
    private weak var delegate: QuestionGeneratorDelegate?
    
    // MARK: - Init
    init(moviesLoader: MoviesLoadingProtocol, delegate: QuestionGeneratorDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    // MARK: - Methods
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            let ratingThrashold = Constants.ratingThresholds.randomElement() ?? 5
            let isLessOrGreater = Bool.random()
            let comparisonText = isLessOrGreater ? L10n.questionLessThan : L10n.questionGreaterThan
            let text = "\(L10n.questionText)\n\(comparisonText) \(Int(ratingThrashold))?"
            let correctAnswer = isLessOrGreater ? (rating < ratingThrashold) : (rating > ratingThrashold)
            
            let question = QuizQuestion(
                image: imageData,
                text: text,
                correctAnswer: correctAnswer
            )
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
