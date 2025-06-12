//
//  TodoRepository.swift
//  CleanTodoList
//
//  Created by Apple on 5/21/25.
//

import Foundation

struct TodoRepository: TodoRepositoryProtocol {
   
    private let coreDataStorage: TodoCoreDataProtocol
    
    init(coreDataManager: TodoCoreDataProtocol) {
        self.coreDataStorage = coreDataManager
    }
    
    func saveTodoItem(item: TodoItem) -> Result<Bool, CoreDataError> {
        coreDataStorage.saveTodoItem(item: item)
    }
    
    func readTodoList(page: Int, limit: Int) -> Result<[TodoItem], CoreDataError> {
        coreDataStorage.readTodoList(page: page, limit: limit)
    }
    
    func updateTodoItem(item: TodoItem) -> Result<Bool, CoreDataError> {
        coreDataStorage.updateTodoItem(item: item)
    }
    
    func deleteTodoItem(item: TodoItem) -> Result<Bool, CoreDataError> {
        coreDataStorage.deleteTodoItem(item: item)
    }
    
}
