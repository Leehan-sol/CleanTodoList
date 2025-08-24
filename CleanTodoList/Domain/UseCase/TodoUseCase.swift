//
//  TodoUseCase.swift
//  CleanTodoList
//
//  Created by Apple on 5/21/25.
//

import Foundation
import RxSwift

protocol TodoUseCaseProtocol {
    func saveTodoItem(item: TodoItem) -> Single<Bool>
    func readTodoList(page: Int, limit: Int, type: FilterType) -> Single<[TodoItem]>
    func updateTodoItem(item: TodoItem) -> Single<TodoItem>
    func deleteTodoItem(item: TodoItem) -> Single<TodoItem>
}

class TodoUseCase: TodoUseCaseProtocol {
    
    private let todoRepository: TodoRepositoryProtocol
    
    init(todoRepository: TodoRepositoryProtocol) {
        self.todoRepository = todoRepository
    }
    
    func saveTodoItem(item: TodoItem) -> Single<Bool> {
        todoRepository.saveTodoItem(item: item)
    }
    
    func readTodoList(page: Int, limit: Int, type: FilterType) -> Single<[TodoItem]> {
        todoRepository.readTodoList(page: page, limit: limit, type: type)
    }
    
    func updateTodoItem(item: TodoItem) -> Single<TodoItem> {
        todoRepository.updateTodoItem(item: item)
    }
    
    func deleteTodoItem(item: TodoItem) -> Single<TodoItem> {
        todoRepository.deleteTodoItem(item: item)
    }

}
