//
//  TodoUseCaseTests.swift
//  CleanTodoListTests
//
//  Created by hansol on 2025/07/14.
//

import XCTest
@testable import CleanTodoList

final class TodoUseCaseTests: XCTestCase {
    var mockRepository: MockTodoRepository!
    var useCase: TodoUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockTodoRepository()
        useCase = TodoUseCase(todoRepository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }
    
    func test_saveTodoItem() {
        let item = TodoItem(uuid: UUID(), title: "저장 테스트", done: false, date: Date())
        
        let result = useCase.saveTodoItem(item: item)
        
        switch result {
        case .success(let success):
            XCTAssertTrue(success)
            XCTAssertEqual(mockRepository.savedItems.first?.title, "저장 테스트")
        case .failure:
            XCTFail("저장 실패")
        }
    }
    
    func test_readTodoList() {
        let expectedItems = [
            TodoItem(uuid: UUID(), title: "테스트1", done: false, date: Date()),
            TodoItem(uuid: UUID(), title: "테스트2", done: false, date: Date())
        ]
        mockRepository.readResult = .success(expectedItems)
        
        let result = useCase.readTodoList(page: 1, limit: 10, type: .all)
        
        switch result {
        case .success(let items):
            XCTAssertEqual(items.count, expectedItems.count)
            XCTAssertEqual(items.first?.title, "테스트1")
        case .failure:
            XCTFail("읽기 실패")
        }
    }
    
    func test_updateTodoItem() {
        mockRepository.updateResult = .success(true)
        let item = TodoItem(uuid: UUID(), title: "테스트", done: false, date: Date())
        
        let result = useCase.updateTodoItem(item: item)
        
        switch result {
        case .success(let success):
            XCTAssertTrue(success)
        case .failure:
            XCTFail("업데이트 실패")
        }
    }
    
    func test_deleteTodoItem() {
        mockRepository.deleteResult = .success(true)
        let item = TodoItem(uuid: UUID(), title: "테스트", done: false, date: Date())
        
        let result = useCase.deleteTodoItem(item: item)
        
        switch result {
        case .success(let success):
            XCTAssertTrue(success)
        case .failure:
            XCTFail("삭제 실패")
        }
    }
}
