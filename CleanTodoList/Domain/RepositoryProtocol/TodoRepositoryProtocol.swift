//
//  TodoRepositoryProtocol.swift
//  CleanTodoList
//
//  Created by Apple on 5/21/25.
//

import Foundation

protocol TodoRepositoryProtocol {
    func saveTodoItem(item: TodoItem) -> Result<Bool, CoreDataError>
    func readTodoList() -> Result<[TodoItem], CoreDataError>
    func updateTodoItem(item: TodoItem) -> Result<Bool, CoreDataError>
    func deleteTodoItem(item: TodoItem) -> Result<Bool, CoreDataError>
}
