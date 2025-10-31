//
//  QuestionRandomizerProtocol.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 31. 10. 2025..
//

import Foundation

protocol QuestionRandomizerProtocol {
    func randomizeIndex(upperBound: Int) -> Int
    func randomBool() -> Bool
    func randomThreshold() -> Float
}
