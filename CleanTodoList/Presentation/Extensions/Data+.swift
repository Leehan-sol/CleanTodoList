//
//  Data+.swift
//  CleanTodoList
//
//  Created by Apple on 6/12/25.
//

import Foundation

extension Date {
    func toDisplayString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yy-MM-dd HH:mm"
        return formatter.string(from: self)
    }
}

