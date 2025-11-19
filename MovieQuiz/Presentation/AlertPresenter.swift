//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 24. 10. 2025..
//

import UIKit

final class AlertPresenter: AlertPresentingProtocol {
    
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func showAlert(model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.text, preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion?()
        }
        
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
}
