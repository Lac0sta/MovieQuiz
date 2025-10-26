//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 26. 10. 2025..
//

import Foundation

struct MostPopularMovies: Decodable {
    let errorMessage: String
    let items: [MostPopularMovie]
}
