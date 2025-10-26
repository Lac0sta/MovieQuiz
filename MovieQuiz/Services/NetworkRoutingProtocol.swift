//
//  NetworkRoutingProtocol.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 26. 10. 2025..
//

import Foundation

protocol NetworkRoutingProtocol {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
