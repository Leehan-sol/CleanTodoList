//
//  MockTodoUseCase.swift
//  CleanTodoList
//
//  Created by Apple on 8/1/25.
//

import XCTest
import RxSwift
@testable import CleanTodoList

final class MockTodoUseCase: TodoUseCaseProtocol {
    private var readItems: [TodoItem] = [
        TodoItem(uuid: UUID(), title: "Todo_1", done: false, date: Date()),
        TodoItem(uuid: UUID(), title: "Todo_2", done: true, date: Date())
    ]
 
    func saveTodoItem(item: TodoItem) -> Single<Bool> {
        print("MockUseCase - saveTodoItem")
        readItems.append(item)
        return .just(true)
    }
    
    func readTodoList(page: Int, limit: Int, type: FilterType) -> Single<[TodoItem]> {
        print("MockUseCase - readTodoItem")
        return .just(readItems)
    }
    
    func updateTodoItem(item: TodoItem) -> Single<TodoItem> {
        print("MockUseCase - updateTodoItem")
        if let index = readItems.firstIndex(where: { $0.uuid == item.uuid }) {
            readItems[index] = item
            return .just(item)
        }
        return .error(CoreDataError.updateError("업데이트 에러"))
    }
    
    func deleteTodoItem(item: TodoItem) -> Single<TodoItem> {
        print("MockUseCase - deleteTodoItem")
        if let index = readItems.firstIndex(where: { $0.uuid == item.uuid }) {
            readItems.remove(at: index)
            return .just(item)
        }
        return .error(CoreDataError.updateError("삭제 에러"))
    }
    
}

