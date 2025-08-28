//
//  TodoUseCaseTests.swift
//  CleanTodoListTests
//
//  Created by hansol on 2025/07/14.
//

import XCTest
import RxSwift
@testable import CleanTodoList

final class TodoUseCaseTests: XCTestCase {
    private var mockRepository: MockTodoRepository!
    private var useCase: TodoUseCase!
    private var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockTodoRepository()
        useCase = TodoUseCase(todoRepository: mockRepository)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        super.tearDown()
        mockRepository = nil
        useCase = nil
        disposeBag = nil
    }
    
    func test_saveTodoItem() {
        // Given
        let item = TodoItem(uuid: UUID(), title: "저장 테스트", done: false, date: Date())
        
        // When & Then
        useCase.saveTodoItem(item: item).asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] success in
                guard let self = self else { return }
                XCTAssertTrue(success)
                XCTAssertEqual(mockRepository.savedItems.first?.title, "저장 테스트")
            },
                       onError: { error in
                XCTFail("저장 실패")
            }).disposed(by: disposeBag)
    }
    
    func test_readTodoList() {
        // Given
        let expectedItems = [
            TodoItem(uuid: UUID(), title: "테스트1", done: false, date: Date()),
            TodoItem(uuid: UUID(), title: "테스트2", done: false, date: Date())
        ]
        mockRepository.readResult = .just(expectedItems)
        
        // When & Then
        useCase.readTodoList(page: 1, limit: 10, type: .all).asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { items in
                XCTAssertEqual(items.count, expectedItems.count)
                XCTAssertEqual(items.first?.title, "테스트1")
            },
                       onError: { error in
                XCTFail("읽기 실패")
            }).disposed(by: disposeBag)
    }
    
    func test_updateTodoItem() {
        // Given
        let item = TodoItem(uuid: UUID(), title: "업데이트 아이템", done: false, date: Date())
        mockRepository.updateResult = .just(item)
        
        // When & Then
        useCase.updateTodoItem(item: item).asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] items in
                guard let self = self else { return }
                XCTAssertTrue(mockRepository.isUpdateCalled)
                XCTAssertEqual(mockRepository.updateItemParam?.title, "업데이트 아이템")
            },
                       onError: { error in
                XCTFail("업데이트 실패")
            }).disposed(by: disposeBag)
    }
    
    func test_deleteTodoItem() {
        let item = TodoItem(uuid: UUID(), title: "삭제 아이템", done: false, date: Date())
        mockRepository.deleteResult = .just(item)
        
        // When & Then
        useCase.deleteTodoItem(item: item).asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                XCTAssertTrue(mockRepository.isDeleteCalled)
                XCTAssertEqual(mockRepository.deleteItemParam?.title, "삭제 아이템")
            },
                       onError: { error in
                XCTFail("삭제 실패")
            }).disposed(by: disposeBag)
    }
    
    
}
