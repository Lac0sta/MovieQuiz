//
//  StatisticsService.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 26. 10. 2025..
//

import Foundation

final class StatisticsService: StatisticsServiceProtocol {
    
    private enum Keys: String {
        case correctAnswers, totalQuestions, gamesCount, bestGame
    }
    
    private let userDefaults: UserDefaults = .standard
    
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameResult.self, from: data) else {
                return GameResult(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Not possible to save the result")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            let correctAnswers = userDefaults.integer(forKey: Keys.correctAnswers.rawValue)
            let totalQuestions = userDefaults.integer(forKey: Keys.totalQuestions.rawValue)
            
            guard totalQuestions > 0 else { return 0 }
            return Double(correctAnswers) / Double(totalQuestions) * 100
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let currentGame = GameResult(correct: count, total: amount, date: Date())
        
        if currentGame.isBetterThan(bestGame) {
            bestGame = currentGame
        }
        
        gamesCount += 1
        
        let correctAnswers = userDefaults.integer(forKey: Keys.correctAnswers.rawValue) + count
        let totalQuestions = userDefaults.integer(forKey: Keys.totalQuestions.rawValue) + amount
        
        userDefaults.set(correctAnswers, forKey: Keys.correctAnswers.rawValue)
        userDefaults.set(totalQuestions, forKey: Keys.totalQuestions.rawValue)
    }
}
