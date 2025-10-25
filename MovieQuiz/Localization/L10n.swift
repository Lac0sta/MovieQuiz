//
//  L10n.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 22. 10. 2025..
//

import Foundation

enum L10n {
    static var questionTitle: String { NSLocalizedString("question.title", comment: "") }
    static var questionText: String { NSLocalizedString("question.text", comment: "") }
    static var buttonYes: String { NSLocalizedString("button.yes", comment: "") }
    static var buttonNo: String { NSLocalizedString("button.no", comment: "") }
    static var resultTitle: String { NSLocalizedString("result.title", comment: "") }
    static var resultText: String { NSLocalizedString("result.text", comment: "") }
    static var resultTotal: String { NSLocalizedString("result.total", comment: "") }
    static var resultRecord: String { NSLocalizedString("result.record", comment: "") }
    static var resultAccuracy: String { NSLocalizedString("result.accuracy", comment: "") }
    static var restartButton: String { NSLocalizedString("restart.button", comment: "") }
}
