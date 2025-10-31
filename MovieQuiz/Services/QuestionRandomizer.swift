//
//  QuestionRandomizer.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 31. 10. 2025..
//

import Foundation

final class QuestionRandomizer: QuestionRandomizerProtocol {
    
    func randomizeIndex(upperBound: Int) -> Int {
        Int.random(in: 0..<upperBound)
    }
    
    func randomBool() -> Bool {
        Bool.random()
    }
    
    func randomThreshold() -> Float {
        Constants.ratingThresholds.randomElement() ?? 5
    }
}
