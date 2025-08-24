//
//  TodoRepository.swift
//  CleanTodoList
//
//  Created by Apple on 5/21/25.
//

import Foundation
import RxSwift

struct TodoRepository: TodoRepositoryProtocol {
   
    private let coreDataStorage: TodoCoreDataProtocol
    
    init(coreDataManager: TodoCoreDataProtocol) {
        self.coreDataStorage = coreDataManager
    }
    
    func saveTodoItem(item: TodoItem) -> Single<Bool> {
        coreDataStorage.saveTodoItem(item: item)
    }
    
    func readTodoList(page: Int, limit: Int, type: FilterType) -> Single<[TodoItem]> {
        coreDataStorage.readTodoList(page: page, limit: limit, type: type)
    }
    
    func updateTodoItem(item: TodoItem) -> Single<TodoItem> {
        coreDataStorage.updateTodoItem(item: item)
    }
    
    func deleteTodoItem(item: TodoItem) -> Single<TodoItem> {
        coreDataStorage.deleteTodoItem(item: item)
    }
    
}
