//
//  TodoRepository.swift
//  CleanTodoList
//
//  Created by Apple on 5/21/25.
//

import Foundation

struct TodoRepository: TodoRepositoryProtocol {
   
    private let coreDataManager: TodoCoreDataProtocol
    
    init(coreDataManager: TodoCoreDataProtocol) {
        self.coreDataManager = coreDataManager
    }
    
    func saveTodoItem(item: TodoItem) -> Result<Bool, CoreDataError> {
        coreDataManager.saveTodoItem(item: item)
    }
    
    func readTodoList() -> Result<[TodoItem], CoreDataError> {
        coreDataManager.readTodoList()
    }
    
    func updateTodoItem(item: TodoItem) -> Result<Bool, CoreDataError> {
        coreDataManager.updateTodoItem(item: item)
    }
    
    func deleteTodoItem(item: TodoItem) -> Result<Bool, CoreDataError> {
        coreDataManager.deleteTodoItem(item: item)
    }
    
}
