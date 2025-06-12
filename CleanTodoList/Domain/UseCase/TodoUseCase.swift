//
//  TodoUseCase.swift
//  CleanTodoList
//
//  Created by Apple on 5/21/25.
//

import Foundation

protocol TodoUseCaseProtocol {
    func saveTodoItem(item: TodoItem) -> Result<Bool, CoreDataError>
    func readTodoList(page: Int, limit: Int) -> Result<[TodoItem], CoreDataError>
    func updateTodoItem(item: TodoItem) -> Result<Bool, CoreDataError>
    func deleteTodoItem(item: TodoItem) -> Result<Bool, CoreDataError>
}

class TodoUseCase: TodoUseCaseProtocol {
    
    private let todoRepository: TodoRepositoryProtocol
    
    init(todoRepository: TodoRepositoryProtocol) {
        self.todoRepository = todoRepository
    }
    
    func saveTodoItem(item: TodoItem) -> Result<Bool, CoreDataError> {
        todoRepository.saveTodoItem(item: item)
    }
    
    func readTodoList(page: Int, limit: Int) -> Result<[TodoItem], CoreDataError> {
        todoRepository.readTodoList(page: page, limit: limit)
    }
    
    func updateTodoItem(item: TodoItem) -> Result<Bool, CoreDataError> {
        todoRepository.updateTodoItem(item: item)
    }
    
    func deleteTodoItem(item: TodoItem) -> Result<Bool, CoreDataError> {
        todoRepository.deleteTodoItem(item: item)
    }

}
