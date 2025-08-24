//
//  CoreDataError.swift
//  CleanTodoList
//
//  Created by Apple on 5/21/25.
//

import Foundation

enum CoreDataError: Error {
    case noData
    case EntityNotFound(String)
    case SaveError(String)
    case ReadError(String)
    case updateError(String)
    case deleteError(String)
    
    var description: String {
        switch self {
        case .noData:
            return "데이터가 없음"
        case .EntityNotFound(let description):
            return "CoreData Entity 찾을 수 없음, \(description)"
        case .SaveError(let description):
            return "저장 실패, \(description)"
        case .ReadError(let description):
            return "읽기 실패, \(description)"
        case .updateError(let description):
            return "수정 실패, \(description)"
        case .deleteError(let description):
            return "삭제 실패, \(description)"
        }
    }
}
