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
    case DeleteError(String)
    
    var description: String {
        switch self {
        case .noData:
            "데이터가 없음"
        case .EntityNotFound(let description):
            "CoreData Entity 찾을 수 없음, \(description)"
        case .SaveError(let description):
            "저장 실패, \(description)"
        case .ReadError(let description):
            "읽기 실패, \(description)"
        case .updateError(let description):
            "수정 실패, \(description)"
        case .DeleteError(let description):
            "삭제 실패, \(description)"
        }
    }
}
