//
//  Constants.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 24. 10. 2025..
//

import Foundation

enum Constants {
    // MARK: - Quiz
    static let timeoutForAnswer = 1.0
    static let questionsAmount = 10
    static let ratingThresholds: [Float] = [5, 6, 7, 8]
    
    // MARK: - API
    enum API {
        static let baseURL = "https://tv-api.com/en/API/"
        static let top250MoviesPath = "Top250Movies"
        static let apiKey = "k_zcuw1ytf"
    }
}
