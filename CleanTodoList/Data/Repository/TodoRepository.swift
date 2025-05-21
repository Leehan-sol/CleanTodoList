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
    
    func getTodoList() -> [TodoItem] {
        coreDataManager.getTodoList()
    }
    
    func saveTodoItem(item: TodoItem) {
        coreDataManager.saveTodoItem(item: item)
    }
    
    func deleteTodoItem(item: TodoItem) {
        coreDataManager.deleteTodoItem(item: item)
    }
    
    func updateTodoItem(item: TodoItem) {
        coreDataManager.updateTodoItem(item: item)
    }
    
    
}
