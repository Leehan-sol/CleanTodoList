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
    private var currentFilterType: FilterType = .all
    private var allTodoItems: [TodoItem] = [TodoItem]()
    
    private let todoItems: BehaviorSubject<[TodoItem]> = BehaviorSubject(value: [])
    private let isLoading: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    private let noMoreData: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    private let coreDataError: PublishSubject<String> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    init(useCase: TodoUseCase) {
        self.useCase = useCase
        self.readTodoItems()
    }
    
    struct Input {
        let saveAction: PublishSubject<TodoItem>
        let readAction: PublishSubject<Void>
        let updateAction: PublishSubject<TodoItem>
        let deleteAction: PublishSubject<TodoItem>
        let filterAction: PublishSubject<FilterType>
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
                let result = self.useCase.saveTodoItem(item: item)
                self.handleResult(result: result)
            }).disposed(by: disposeBag)
        
        input.readAction
            .bind(onNext: {
                self.readTodoItems()
            }).disposed(by: disposeBag)
        
        input.updateAction
            .bind(onNext: { [weak self] item in
                guard let self = self else { return }
                let result = self.useCase.updateTodoItem(item: item)
                self.handleResult(result: result)
            }).disposed(by: disposeBag)
        
        input.deleteAction
            .bind(onNext: { [weak self] item in
                guard let self = self else { return }
                let result = self.useCase.deleteTodoItem(item: item)
                self.handleResult(result: result)
            }).disposed(by: disposeBag)
        
        input.filterAction
            .bind(onNext: { [weak self] type in
                guard let self = self else { return }
                self.currentFilterType = type
                self.showFilterData(type: type, items: allTodoItems)
            }).disposed(by: disposeBag)
          
        return Output(todoItems: todoItems, isLoading: isLoading, noMoreData: noMoreData, coreDataError: coreDataError)
    }
    
    private func readTodoItems() {
        self.isLoading.onNext(true)
        let result = useCase.readTodoList()
        handleListResult(result: result)
        self.isLoading.onNext(false)
    }
    
    private func handleResult(result: Result<Bool, CoreDataError>) {
        switch result {
        case .success:
            self.readTodoItems()
        case .failure(let error):
            self.coreDataError.onNext(error.description)
        }
    }
 
    private func handleListResult(result: Result<[TodoItem], CoreDataError>) {
        switch result {
        case .success(let items):
            // TODO: - 페이지네이션, noMoreData.onNext
            allTodoItems = items
            self.showFilterData(type: currentFilterType, items: items)
            break
        case .failure(let error):
            self.coreDataError.onNext(error.description)
        }
    }
    
    private func showFilterData(type: FilterType, items: [TodoItem]) {
        switch type {
        case .all:
            self.todoItems.onNext(items)
        case .done:
            self.todoItems.onNext(items.filter{ $0.done == true })
        }
    }
    
}

