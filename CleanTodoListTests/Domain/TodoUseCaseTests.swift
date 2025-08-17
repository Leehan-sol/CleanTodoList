//
//  TodoUseCaseTests.swift
//  CleanTodoListTests
//
//  Created by hansol on 2025/07/14.
//

import XCTest
@testable import CleanTodoList

final class TodoUseCaseTests: XCTestCase {
    private var mockRepository: MockTodoRepository!
    private var useCase: TodoUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockTodoRepository()
        useCase = TodoUseCase(todoRepository: mockRepository)
    }

    override func tearDown() {
        super.tearDown()
        mockRepository = nil
        useCase = nil
    }
    
    func test_saveTodoItem() {
        // Given
        let item = TodoItem(uuid: UUID(), title: "저장 테스트", done: false, date: Date())
        
        // When
        let result = useCase.saveTodoItem(item: item)
        
        // Then
        switch result {
        case .success(let success):
            XCTAssertTrue(success)
            XCTAssertEqual(mockRepository.savedItems.first?.title, "저장 테스트")
        case .failure:
            XCTFail("저장 실패")
        }
    }
    
    func test_readTodoList() {
        // Given
        let expectedItems = [
            TodoItem(uuid: UUID(), title: "테스트1", done: false, date: Date()),
            TodoItem(uuid: UUID(), title: "테스트2", done: false, date: Date())
        ]
        mockRepository.readResult = .success(expectedItems)
        
        // When
        let result = useCase.readTodoList(page: 1, limit: 10, type: .all)
        
        // Then
        switch result {
        case .success(let items):
            XCTAssertEqual(items.count, expectedItems.count)
            XCTAssertEqual(items.first?.title, "테스트1")
        case .failure:
            XCTFail("읽기 실패")
        }
    }
    
    func test_updateTodoItem() {
        // Given
        let item = TodoItem(uuid: UUID(), title: "업데이트 아이템", done: false, date: Date())
        mockRepository.updateResult = .success(true)
        
        // When
        let result = useCase.updateTodoItem(item: item)
        
        // Then
        switch result {
        case .success(let success):
            XCTAssertTrue(mockRepository.isUpdateCalled)
            XCTAssertEqual(mockRepository.updateItemParam?.title, "업데이트 아이템")
            XCTAssertTrue(success)
        case .failure:
            XCTFail("업데이트 실패")
        }
    }
    
    func test_deleteTodoItem() {
        let item = TodoItem(uuid: UUID(), title: "삭제 아이템", done: false, date: Date())
        mockRepository.deleteResult = .success(true)
        
        let result = useCase.deleteTodoItem(item: item)
        
        switch result {
        case .success(let success):
            XCTAssertTrue(mockRepository.isDeleteCalled)
            XCTAssertEqual(mockRepository.deleteItemParam?.title, "삭제 아이템")
            XCTAssertTrue(success)
        case .failure:
            XCTFail("삭제 실패")
        }
    }
}
