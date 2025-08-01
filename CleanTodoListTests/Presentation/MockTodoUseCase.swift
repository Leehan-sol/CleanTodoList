//
//  MockTodoUseCase.swift
//  CleanTodoList
//
//  Created by Apple on 8/1/25.
//

import XCTest
@testable import CleanTodoList

final class MockTodoUseCase: TodoUseCaseProtocol {
    func saveTodoItem(item: TodoItem) -> Result<Bool, CoreDataError> {
        return .success(true)
    }
    
    func readTodoList(page: Int, limit: Int, type: FilterType) -> Result<[TodoItem], CoreDataError> {
        <#code#>
    }
    
    func updateTodoItem(item: TodoItem) -> Result<Bool, CoreDataError> {
        <#code#>
    }
    
    func deleteTodoItem(item: TodoItem) -> Result<Bool, CoreDataError> {
        <#code#>
    }
    
    
}
