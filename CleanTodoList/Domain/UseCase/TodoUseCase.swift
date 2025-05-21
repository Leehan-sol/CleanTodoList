//
//  TodoUseCase.swift
//  CleanTodoList
//
//  Created by Apple on 5/21/25.
//

import Foundation

protocol TodoUseCaseProtocol {
    func getTodoList() -> [TodoItem]
    func saveTodoItem(item: TodoItem)
    func deleteTodoItem(item: TodoItem)
    func updateTodoItem(item: TodoItem)
}

class TodoUseCase: TodoUseCaseProtocol {
    
    private let todoRepository: TodoRepositoryProtocol
    
    init(todoRepository: TodoRepositoryProtocol) {
        self.todoRepository = todoRepository
    }
    
    func getTodoList() -> [TodoItem] {
        todoRepository.getTodoList()
    }
    
    func saveTodoItem(item: TodoItem) {
        todoRepository.saveTodoItem(item: item)
    }
    
    func deleteTodoItem(item: TodoItem) {
        todoRepository.deleteTodoItem(item: item)
    }
    
    func updateTodoItem(item: TodoItem) {
        todoRepository.updateTodoItem(item: item)
    }
    
}
