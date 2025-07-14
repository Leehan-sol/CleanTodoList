//
//  MockTodoRepository.swift
//  CleanTodoListTests
//
//  Created by hansol on 2025/07/14.
//

import Foundation
@testable import CleanTodoList

final class MockTodoRepository: TodoRepositoryProtocol {
    var savedItems: [TodoItem] = []
    var readResult: Result<[TodoItem], CoreDataError> = .success([])
    var saveResult: Result<Bool, CoreDataError> = .success(true)
    var updateResult: Result<Bool, CoreDataError> = .success(true)
    var deleteResult: Result<Bool, CoreDataError> = .success(true)
    
    func saveTodoItem(item: TodoItem) -> Result<Bool, CoreDataError> {
        savedItems.append(item)
        return saveResult
    }
    
    func readTodoList(page: Int, limit: Int, type: FilterType) -> Result<[TodoItem], CoreDataError> {
        return readResult
    }
    
    func updateTodoItem(item: TodoItem) -> Result<Bool, CoreDataError> {
        return updateResult
    }
    
    func deleteTodoItem(item: TodoItem) -> Result<Bool, CoreDataError> {
        return deleteResult
    }
}

