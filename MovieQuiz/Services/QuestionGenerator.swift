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
    private let questionRandomizer: QuestionRandomizerProtocol
    private var movies: [MostPopularMovie] = []
    private var usedMovieIndices: Set<Int> = []
    
    // MARK: - Delegate
    private weak var delegate: QuestionGeneratorDelegate?
    
    // MARK: - Init
    init(
        moviesLoader: MoviesLoadingProtocol,
        questionRandomizer: QuestionRandomizerProtocol = QuestionRandomizer(),
        delegate: QuestionGeneratorDelegate?
    ) {
        self.moviesLoader = moviesLoader
        self.questionRandomizer = questionRandomizer
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
            guard let movie = self.pickRandomMovie() else { return }
            
            let imageData = self.loadImageData(fom: movie)
            let question = self.makeQuestion(from: movie, imageData: imageData)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    func pickRandomMovie() -> MostPopularMovie? {
        guard movies.isNotEmpty else { return nil }
        
        let availableIndices = (0..<movies.count).filter { !usedMovieIndices.contains($0) }
        
        guard let randomIndex = availableIndices.randomElement() else {
            usedMovieIndices.removeAll()
            return pickRandomMovie()
        }
        
        usedMovieIndices.insert(randomIndex)
        return movies[safe: randomIndex]
    }
    
    func loadImageData(fom movie: MostPopularMovie) -> Data {
        do {
            return try Data(contentsOf: movie.resizedImageURL)
        } catch {
            print("Failed to load image: \(error)")
            return Data()
        }
    }
    
    func makeQuestion(from movie: MostPopularMovie, imageData: Data) -> QuizQuestion {
        let rating = Float(movie.rating) ?? 0
        let threshold = questionRandomizer.randomThreshold()
        let isLess = questionRandomizer.randomBool()
        
        let text = buildQuestionText(
            base: L10n.questionText,
            isLess: isLess,
            threshold: threshold
        )
        
        let correct = evaluate(
            movieRating: rating,
            isLess: isLess,
            threshold: threshold
        )
        
        return QuizQuestion(
            image: imageData,
            text: text,
            correctAnswer: correct
        )
    }
    
    func buildQuestionText(base: String, isLess: Bool, threshold: Float) -> String {
        let comparison = isLess ? L10n.questionLessThan : L10n.questionGreaterThan
        return "\(base)\n\(comparison) \(Int(threshold))?"
    }
    
    func evaluate(movieRating: Float, isLess: Bool, threshold: Float) -> Bool {
        if isLess {
            return movieRating < threshold
        } else {
            return movieRating > threshold
        }
    }
}
