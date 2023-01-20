//
//  Task.swift
//  GoodList
//
//  Created by 김병엽 on 2023/01/20.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
