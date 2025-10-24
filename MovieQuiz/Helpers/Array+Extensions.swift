//
//  Array+Extensions.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 24. 10. 2025..
//

import Foundation

extension Array {
    subscript (safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
