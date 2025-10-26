//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 26. 10. 2025..
//

import Foundation

struct MoviesLoader: MoviesLoadingProtocol {
    
    private let networkClient: NetworkRoutingProtocol = NetworkClient()
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(
            string: Constants.API.baseURL
            + Constants.API.top250MoviesPath
            + "/"
            + Constants.API.apiKey
        ) else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, any Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMovies))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
