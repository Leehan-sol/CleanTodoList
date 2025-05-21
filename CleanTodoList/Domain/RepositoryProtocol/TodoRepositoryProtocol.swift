//
//  TodoRepositoryProtocol.swift
//  CleanTodoList
//
//  Created by Apple on 5/21/25.
//

import Foundation

protocol TodoRepositoryProtocol {
    func getTodoList() -> [TodoItem]
    func saveTodoItem(item: TodoItem)
    func deleteTodoItem(item: TodoItem)
    func updateTodoItem(item: TodoItem)
}
