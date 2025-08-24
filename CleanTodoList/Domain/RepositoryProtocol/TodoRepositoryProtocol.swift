//
//  TodoRepositoryProtocol.swift
//  CleanTodoList
//
//  Created by Apple on 5/21/25.
//

import Foundation
import RxSwift

protocol TodoRepositoryProtocol {
    func saveTodoItem(item: TodoItem) -> Single<Bool>
    func readTodoList(page: Int, limit: Int, type: FilterType) -> Single<[TodoItem]>
    func updateTodoItem(item: TodoItem) -> Single<TodoItem>
    func deleteTodoItem(item: TodoItem) -> Single<TodoItem>
}
