//
//  MostPopularMovie.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 26. 10. 2025..
//

import Foundation

struct MostPopularMovie: Decodable {
    let title: String
    let rating: String
    let imageURL: URL
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
