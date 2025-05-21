//
//  CoreDataManager.swift
//  CleanTodoList
//
//  Created by Apple on 5/21/25.
//

import UIKit
import CoreData

protocol TodoCoreDataProtocol {
    func getTodoList() -> [TodoItem]
    func saveTodoItem(item: TodoItem)
    func deleteTodoItem(item: TodoItem)
    func updateTodoItem(item: TodoItem)
}

struct TodoCoreData: TodoCoreDataProtocol {
    
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // TODO: - 비즈니스 로직 구현해야함
    func getTodoList() -> [TodoItem] {
        return [TodoItem(title: "", done: false)]
    }
    
    func saveTodoItem(item: TodoItem) {
    
    }
    
    func deleteTodoItem(item: TodoItem) {
        
    }
    
    func updateTodoItem(item: TodoItem) {
        
    }

    
}


