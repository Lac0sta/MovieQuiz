//
//  AlertPresentingProtocol.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 13. 11. 2025..
//

import Foundation

protocol AlertPresentingProtocol: AnyObject {
    func showAlert(model: AlertModel)
}
