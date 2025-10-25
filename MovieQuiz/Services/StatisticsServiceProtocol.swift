//
//  StatisticsServiceProtocol.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 26. 10. 2025..
//

import Foundation

protocol StatisticsServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}
