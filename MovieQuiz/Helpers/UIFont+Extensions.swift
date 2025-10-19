//
//  UIFont+Extensions.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 19. 10. 2025..
//

import UIKit

extension UIFont {
    static var ysDisplayBold23: UIFont {
        UIFont(name: "YS Display-Bold", size: 23) ?? UIFont.systemFont(ofSize: 23, weight: .bold)
    }
    
    static var ysDisplayMedium20: UIFont {
        UIFont(name: "YS Display-Medium", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .medium)
    }
}
