//
//  Extensions.swift
//  Netflix Clone
//
//  Created by CharismaInfotainment on 02/05/23.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
