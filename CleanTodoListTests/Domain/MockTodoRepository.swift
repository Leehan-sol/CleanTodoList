//
//  MockTodoRepository.swift
//  CleanTodoListTests
//
//  Created by hansol on 2025/07/14.
//

import Foundation
@testable import CleanTodoList

final class MockTodoRepository: TodoRepositoryProtocol {
    var readResult: Result<[TodoItem], CoreDataError> = .success([])
    var saveResult: Result<Bool, CoreDataError> = .success(true)
    var updateResult: Result<Bool, CoreDataError> = .success(true)
    var deleteResult: Result<Bool, CoreDataError> = .success(true)
    
    var savedItems: [TodoItem] = []
    
    var isUpdateCalled = false
    var updateItemParam: TodoItem?
    
    var isDeleteCalled = false
    var deleteItemParam: TodoItem?
    
    func saveTodoItem(item: TodoItem) -> Result<Bool, CoreDataError> {
        savedItems.append(item)
        return saveResult
    }
    
    func readTodoList(page: Int, limit: Int, type: FilterType) -> Result<[TodoItem], CoreDataError> {
        return readResult
    }
    
    func updateTodoItem(item: TodoItem) -> Result<Bool, CoreDataError> {
        isUpdateCalled = true
        updateItemParam = item
        return updateResult
    }
    
    func deleteTodoItem(item: TodoItem) -> Result<Bool, CoreDataError> {
        isDeleteCalled = true
        deleteItemParam = item
        return deleteResult
    }
}

