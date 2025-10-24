//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 22. 10. 2025..
//  Model used to display the alerts.

import Foundation

struct AlertModel {
    let title: String
    let text: String
    let buttonText: String
    let completion: (() -> Void)?
}
