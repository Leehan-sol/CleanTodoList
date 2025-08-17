//
//  TodoViewModelTests.swift
//  CleanTodoListTests
//
//  Created by hansol on 2025/07/14.
//

import XCTest
import RxSwift
@testable import CleanTodoList

final class TodoViewModelTests: XCTestCase {
    private var mockTodoUseCase: TodoUseCaseProtocol!
    private var viewModel: TodoViewModelProtocol!
    private var disposeBag: DisposeBag!
    
    private var saveAction: PublishSubject<TodoItem>!
    private var readAction: PublishSubject<Void>!
    private var updateAction: PublishSubject<TodoItem>!
    private var deleteAction: PublishSubject<TodoItem>!
    private var filterAction: PublishSubject<FilterType>!
    private var refreshAction: PublishSubject<Void>!
    
    override func setUp() {
        super.setUp()
        mockTodoUseCase = MockTodoUseCase()
        viewModel = TodoViewModel(useCase: mockTodoUseCase)
        disposeBag = DisposeBag()
        saveAction = PublishSubject<TodoItem>()
        readAction = PublishSubject<Void>()
        updateAction = PublishSubject<TodoItem>()
        deleteAction = PublishSubject<TodoItem>()
        filterAction = PublishSubject<FilterType>()
        refreshAction = PublishSubject<Void>()
    }
    
    override func tearDown() {
        super.tearDown()
        mockTodoUseCase = nil
        viewModel = nil
        disposeBag = nil
        disposeBag = nil
        saveAction = nil
        readAction = nil
        updateAction = nil
        deleteAction = nil
        filterAction = nil
        refreshAction = nil
    }
    
    func test_readTodoList() {
        // Given
        let readItems: [TodoItem] = [
            TodoItem(uuid: UUID(), title: "Todo_1", done: false, date: Date()),
            TodoItem(uuid: UUID(), title: "Todo_2", done: true, date: Date())
        ]
        
        let readExpectation = self.expectation(description: "readTodoItems")
        var receivedItems: [TodoItem]?
        
        let input = TodoViewModel.Input(
            saveAction: saveAction,
            readAction: readAction,
            updateAction: updateAction,
            deleteAction: deleteAction,
            filterAction: filterAction,
            refreshAction: refreshAction
        )
        
        viewModel.transform(input: input)
            .todoItems
            .take(1)
            .subscribe(onNext: { items in
                receivedItems = items
                readExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        // When
        readAction.onNext(())
        
        // Then
        waitForExpectations(timeout: 2.0, handler: nil)
        XCTAssertNotNil(receivedItems)
        XCTAssertEqual(receivedItems!.count, readItems.count)
        XCTAssertEqual(receivedItems!.first?.title, readItems.first?.title)
    }
    
    func test_saveTodoItem() {
        // Given
        let newItem = TodoItem(uuid: UUID(), title: "Todo_3", done: false, date: Date())
        let saveExpectation = self.expectation(description: "saveTodoItems")
        var receivedItems: [TodoItem]?
        
        let input = TodoViewModel.Input(
            saveAction: saveAction,
            readAction: readAction,
            updateAction: updateAction,
            deleteAction: deleteAction,
            filterAction: filterAction,
            refreshAction: refreshAction
        )
        
        viewModel.transform(input: input)
            .todoItems
            .skip(1)
            .take(1)
            .subscribe(onNext: { items in
                receivedItems = items
                saveExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        // When
        saveAction.onNext(newItem)
        
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertTrue(receivedItems!.contains(where: { $0.title == "Todo_3" }))
    }
    
    func test_updateTodoItem() {
        // Given
        let saveItem = TodoItem(uuid: UUID(), title: "Todo_test", done: false, date: Date())
        var receivedItems: [TodoItem]?
        
        let updatedItem = TodoItem(uuid: saveItem.uuid, title: "Todo_test_update", done: false, date: Date())
        let updateExpectation = expectation(description: "updateTodoItems")
        
        let input = TodoViewModel.Input(
            saveAction: saveAction,
            readAction: readAction,
            updateAction: updateAction,
            deleteAction: deleteAction,
            filterAction: filterAction,
            refreshAction: refreshAction
        )
        
        viewModel.transform(input: input)
            .todoItems
            .skip(1)
            .subscribe(onNext: { items in
                receivedItems = items
                if items.contains(where: { $0.title == "Todo_test_update" }) {
                    updateExpectation.fulfill()
                }
            })
            .disposed(by: disposeBag)
        
        // When
        saveAction.onNext(saveItem)
        updateAction.onNext(updatedItem)
        
        // Then
        waitForExpectations(timeout: 2.0)
        XCTAssertTrue(receivedItems!.contains(where: { $0.title == "Todo_test_update" }))
    }
    
    
    
    func test_deleteTodoItem() {
        // Given
        let deleteItem = TodoItem(uuid: UUID(), title: "Todo_test_delete", done: false, date: Date())
        var receivedItems: [TodoItem]?
        let deleteExpectation = expectation(description: "deleteTodoItems")
        
        let input = TodoViewModel.Input(
            saveAction: saveAction,
            readAction: readAction,
            updateAction: updateAction,
            deleteAction: deleteAction,
            filterAction: filterAction,
            refreshAction: refreshAction
        )
        
        viewModel.transform(input: input)
            .todoItems
            .skip(1)
            .subscribe(onNext: { items in
                receivedItems = items
                if !items.contains(where: { $0.title == "Todo_test_delete" }) {
                    deleteExpectation.fulfill()
                }
            })
            .disposed(by: disposeBag)
        
        // When
        saveAction.onNext(deleteItem)
        deleteAction.onNext(deleteItem)
        
        // Then
        waitForExpectations(timeout: 2.0)
        XCTAssertTrue(!receivedItems!.contains(where: { $0.title == "Todo_test_delete" }))
    }
    
}
