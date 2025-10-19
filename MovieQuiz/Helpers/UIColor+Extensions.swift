//
//  UIColor+Extensions.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 19. 10. 2025..
//

import UIKit

extension UIColor {
    static var appBackground: UIColor { UIColor(named: "ypBackground") ?? UIColor.black.withAlphaComponent(0.6) }
    static var appBlack: UIColor { UIColor(named: "ypBlack") ?? UIColor.black }
    static var appGray: UIColor { UIColor(named: "ypGray") ?? UIColor.gray }
    static var appGreen: UIColor { UIColor(named: "ypGreen") ?? UIColor.green }
    static var appRed: UIColor { UIColor(named: "ypRed") ?? UIColor.red }
    static var appWhite: UIColor { UIColor(named: "ypWhite") ?? UIColor.white }
}
