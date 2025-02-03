//
//  DateExtension.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2025/2/17.
//

import Foundation

extension Date {
    func dateString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
