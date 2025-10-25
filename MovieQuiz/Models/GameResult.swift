//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 25. 10. 2025..
//

import Foundation

struct GameResult: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameResult) -> Bool {
        self.correct > another.correct
    }
}
