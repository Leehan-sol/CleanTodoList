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
    private let useCase: TodoUseCaseProtocol
    private var currentPage = 1
    private let limit = 20
    private var currentFilterType: FilterType = .all
    private var allTodoItems: [TodoItem] = [TodoItem]()
    
    private let todoItems: BehaviorSubject<[TodoItem]> = BehaviorSubject(value: [])
    private let isLoading: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    private let noMoreData: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    private let coreDataError: PublishSubject<String> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    init(useCase: TodoUseCaseProtocol) {
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
            .flatMap { [weak self] item -> Observable<Bool> in
                guard let self = self else { return Observable.just(false) }
                return useCase.saveTodoItem(item: item).asObservable()
            }
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] success in
                    guard let self = self else { return }
                    if success {
                        refreshTodoItems(type: currentFilterType)
                    }
                },
                onError: { [weak self] error in
                    guard let self = self else { return }
                    handleCoreDataError(error)
                }
            ).disposed(by: disposeBag)
        
        input.readAction
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                readTodoItems(type: currentFilterType)
            }).disposed(by: disposeBag)
        
        input.updateAction
            .flatMap { [weak self] item -> Observable<TodoItem> in
                guard let self = self else { return Observable.empty() }
                return useCase.updateTodoItem(item: item).asObservable()
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] updatedItem in
                guard let self = self else { return }
                
                switch self.currentFilterType {
                case .all:
                    if let index = self.allTodoItems.firstIndex(where: { $0.uuid == updatedItem.uuid }) {
                        self.allTodoItems[index] = updatedItem
                        self.allTodoItems.sort { $0.date > $1.date }
                    }
                case .done:
                    self.refreshTodoItems(type: self.currentFilterType)
                }
                
                self.todoItems.onNext(self.allTodoItems)
                self.noMoreData.onNext(false)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                handleCoreDataError(error)
            }).disposed(by: disposeBag)
        
        input.deleteAction
            .flatMap { [weak self] item -> Observable<TodoItem> in
                guard let self = self else { return Observable.empty() }
                return useCase.deleteTodoItem(item: item).asObservable()
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                allTodoItems.removeAll(where: { $0.uuid == item.uuid })
                todoItems.onNext(allTodoItems)
                noMoreData.onNext(false)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                handleCoreDataError(error)
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
        useCase.readTodoList(page: currentPage, limit: limit, type: type).asObservable()
            .observe(on: MainScheduler.instance)
            .do(onSubscribe: { [weak self] in self?.isLoading.onNext(true) })
            .subscribe(onNext: { [weak self] items in
                guard let self = self else { return }
                self.handleListResult(result: .success(items))
                self.isLoading.onNext(false)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                handleCoreDataError(error)
                self.isLoading.onNext(false)
            })
            .disposed(by: disposeBag)
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
    
    private func handleCoreDataError(_ error: Error) {
        if let coreDataError = error as? CoreDataError {
            self.coreDataError.onNext(coreDataError.description)
        } else {
            self.coreDataError.onNext(error.localizedDescription)
        }
    }
}

