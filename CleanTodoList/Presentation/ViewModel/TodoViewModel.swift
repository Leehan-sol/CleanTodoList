//
//  TodoViewModel.swift
//  CleanTodoList
//
//  Created by Apple on 5/21/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol TodoViewModelProtocol {
    func transform(input: TodoViewModel.Input) -> TodoViewModel.Output
}

class TodoViewModel: TodoViewModelProtocol {
    private let useCase: TodoUseCase
    private var currentPage = 1
    private let limit = 20
    private var currentFilterType: FilterType = .all
    private var allTodoItems: [TodoItem] = [TodoItem]()
    
    private let todoItems: BehaviorSubject<[TodoItem]> = BehaviorSubject(value: [])
    private let isLoading: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    private let noMoreData: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    private let coreDataError: PublishSubject<String> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    init(useCase: TodoUseCase) {
        self.useCase = useCase
        self.readTodoItems(type: currentFilterType)
    }
    
    struct Input {
        let saveAction: PublishSubject<TodoItem>
        let readAction: PublishSubject<Void>
        let updateAction: PublishSubject<TodoItem>
        let deleteAction: PublishSubject<TodoItem>
        let filterAction: PublishSubject<FilterType>
        let refreshAction: PublishSubject<Void>
    }
    
    struct Output {
        let todoItems: BehaviorSubject<[TodoItem]>
        let isLoading: BehaviorSubject<Bool>
        let noMoreData: BehaviorSubject<Bool>
        let coreDataError: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        input.saveAction
            .bind(onNext: { [weak self] item in
                guard let self = self else { return }
                let result = useCase.saveTodoItem(item: item)
                handleResult(action: .save, item: item, result: result)
            }).disposed(by: disposeBag)
        
        input.readAction
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                readTodoItems(type: currentFilterType)
            }).disposed(by: disposeBag)
        
        input.updateAction
            .bind(onNext: { [weak self] item in
                guard let self = self else { return }
                let result = useCase.updateTodoItem(item: item)
                handleResult(action: .update, item: item, result: result)
            }).disposed(by: disposeBag)
        
        input.deleteAction
            .bind(onNext: { [weak self] item in
                guard let self = self else { return }
                let result = useCase.deleteTodoItem(item: item)
                handleResult(action: .delete, item: item, result: result)
            }).disposed(by: disposeBag)
        
        input.filterAction
            .bind(onNext: { [weak self] type in
                guard let self = self else { return }
                currentFilterType = type
                refreshTodoItems(type: type)
            }).disposed(by: disposeBag)
        
        input.refreshAction
            .bind (onNext: { [weak self] _ in
                guard let self = self else { return }
                refreshTodoItems(type: currentFilterType)
            }).disposed(by: disposeBag)
        
        return Output(todoItems: todoItems, isLoading: isLoading, noMoreData: noMoreData, coreDataError: coreDataError)
    }
    
    private func readTodoItems(type: FilterType) {
        self.isLoading.onNext(true)
        let result = useCase.readTodoList(page: currentPage, limit: limit, type: type)
        handleListResult(result: result)
        self.isLoading.onNext(false)
    }
    
    private func refreshTodoItems(type: FilterType) {
        currentPage = 1
        allTodoItems = []
        readTodoItems(type: type)
        noMoreData.onNext(false)
    }
    
    private func handleListResult(result: Result<[TodoItem], CoreDataError>) {
        switch result {
        case .success(let items):
            allTodoItems += items
            self.todoItems.onNext(allTodoItems)
            if items.count == 0 && currentPage != 1 {
                self.noMoreData.onNext(true)
            } else {
                self.currentPage += 1
            }
        case .failure(let error):
            self.coreDataError.onNext(error.description)
        }
    }
    
    private func handleResult(action: TodoActionType, item: TodoItem, result: Result<Bool, CoreDataError>) {
        switch result {
        case .success:
            switch action {
            case .save:
                refreshTodoItems(type: currentFilterType)
            case .update:
                if currentFilterType == .all {
                    guard let index = allTodoItems.firstIndex(where: { $0.uuid == item.uuid }) else { return }
                    allTodoItems[index] = item
                    allTodoItems.sort { $0.date > $1.date }
                  } else if currentFilterType == .done {
                      refreshTodoItems(type: currentFilterType)
                  }
            case .delete:
                allTodoItems.removeAll(where: { $0.uuid == item.uuid })
            }
            todoItems.onNext(allTodoItems)
            noMoreData.onNext(false)
        case .failure(let error):
            self.coreDataError.onNext(error.description)
        }
    }
    
}

