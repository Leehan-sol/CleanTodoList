//
//  MockTodoRepository.swift
//  CleanTodoListTests
//
//  Created by hansol on 2025/07/14.
//

import Foundation
import RxSwift
@testable import CleanTodoList

final class MockTodoRepository: TodoRepositoryProtocol {
    var readResult: Single<[TodoItem]> = .just([])
    var saveResult: Single<Bool> = .just(true)
    var updateResult: Single<TodoItem> = .just(TodoItem(uuid: UUID(), title: "default", done: false, date: Date()))
    var deleteResult: Single<TodoItem> = .just(TodoItem(uuid: UUID(), title: "default", done: false, date: Date()))
    
    var savedItems: [TodoItem] = []
    
    var isUpdateCalled = false
    var updateItemParam: TodoItem?
    
    var isDeleteCalled = false
    var deleteItemParam: TodoItem?
    
    func saveTodoItem(item: TodoItem) -> Single<Bool> {
        savedItems.append(item)
        return saveResult
    }
    
    func readTodoList(page: Int, limit: Int, type: FilterType) -> Single<[TodoItem]> {
        return readResult
    }
    
    func updateTodoItem(item: TodoItem) -> Single<TodoItem> {
        isUpdateCalled = true
        updateItemParam = item
        return updateResult
    }
    
    func deleteTodoItem(item: TodoItem) -> Single<TodoItem> {
        isDeleteCalled = true
        deleteItemParam = item
        return deleteResult
    }
}

