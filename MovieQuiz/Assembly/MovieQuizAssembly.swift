//
//  MovieQuizAssembly.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 13. 11. 2025..
//

import UIKit

enum MovieQuizAssembly {
    static func build() -> UIViewController {
        let viewContorller = MovieQuizViewController()
        
        let moviesLoader: MoviesLoadingProtocol = MoviesLoader()
        let statistics: StatisticsServiceProtocol = StatisticsService()
        let generator = QuestionGenerator(moviesLoader: moviesLoader, delegate: nil)
        
        let alertPresenter = AlertPresenter(viewController: viewContorller)
        
        let presenter = MovieQuizPresenter(
            alertPresenter: alertPresenter,
            questionGenerator: generator,
            statisticsService: statistics,
            questionsAmount: Constants.questionsAmount
        )
        
        presenter.view = viewContorller
        generator.delegate = presenter
        
        viewContorller.configure(presenter: presenter)
        
        return viewContorller
    }
}
