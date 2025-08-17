//
//  MockTodoUseCase.swift
//  CleanTodoList
//
//  Created by Apple on 8/1/25.
//

import XCTest
@testable import CleanTodoList

final class MockTodoUseCase: TodoUseCaseProtocol {
    private var readItems: [TodoItem] = [
        TodoItem(uuid: UUID(), title: "Todo_1", done: false, date: Date()),
        TodoItem(uuid: UUID(), title: "Todo_2", done: true, date: Date())
    ]
 
    func saveTodoItem(item: TodoItem) -> Result<Bool, CoreDataError> {
        print("MockUseCase - saveTodoItem")
        readItems.append(item)
        return .success(true)
    }
    
    func readTodoList(page: Int, limit: Int, type: FilterType) -> Result<[TodoItem], CoreDataError> {
        print("MockUseCase - readTodoItem")
        return .success(readItems)
    }
    
    func updateTodoItem(item: TodoItem) -> Result<Bool, CoreDataError> {
        print("MockUseCase - updateTodoItem")
        if let index = readItems.firstIndex(where: { $0.uuid == item.uuid }) {
            readItems[index] = item
            return .success(true)
        }
        return .failure(.updateError("업데이트 에러"))
    }
    
    func deleteTodoItem(item: TodoItem) -> Result<Bool, CoreDataError> {
        print("MockUseCase - deleteTodoItem")
        if let index = readItems.firstIndex(where: { $0.uuid == item.uuid }) {
            readItems.remove(at: index)
            return .success(true)
        }
        return .failure(.deleteError("삭제 에러"))
    }
    
}

