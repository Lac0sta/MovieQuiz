//
//  Date+Extensions.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 25. 10. 2025..
//

import Foundation

private let dateTimeDefaultFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.YY hh:mm"
    return dateFormatter
}()

extension Date {
    var dateTimeString: String {
        dateTimeDefaultFormatter.string(from: self)
    }
}
