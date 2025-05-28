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
    
    private let todoItems: BehaviorSubject<[TodoItem]> = BehaviorSubject(value: [])
    private let isLoading: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    private let noMoreData: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    private let coreDataError: PublishSubject<String> = PublishSubject()
    private let refreshTrigger: PublishSubject<Void> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    init(useCase: TodoUseCase) {
        self.useCase = useCase
    }
    
    struct Input {
        let saveAction: PublishSubject<TodoItem>
        let readAction: PublishSubject<Void>
        let updateAction: PublishSubject<TodoItem>
        let deleteAction: PublishSubject<TodoItem>
    }
    
    struct Output {
        let todoItems: BehaviorSubject<[TodoItem]>
        let isLoading: BehaviorSubject<Bool>
        let noMoreData: BehaviorSubject<Bool>
        let coreDataError: PublishSubject<String>
        let refreshTrigger: PublishSubject<Void>
    }
    
    func transform(input: Input) -> Output {
        // TODO: - 2) 뷰컨 액션 받아서 할 행동 정의
        input.saveAction
            .bind(onNext: { [weak self] item in
                guard let self = self else { return }
                let result = self.useCase.saveTodoItem(item: item)
                self.handleResult(result: result)
            }).disposed(by: disposeBag)
        
        input.readAction
            .bind(onNext: {
                // TODO: - 페이지네이션
                let result = self.useCase.readTodoList()
                self.handleListResult(result: result)
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
        
        return Output(todoItems: todoItems, isLoading: isLoading, noMoreData: noMoreData, coreDataError: coreDataError, refreshTrigger: refreshTrigger)
    }
    
    private func handleResult(result: Result<Bool, CoreDataError>) {
        switch result {
        case .success:
            break
        case .failure(let error):
            self.coreDataError.onNext(error.description)
        }
    }
 
    private func handleListResult(result: Result<[TodoItem], CoreDataError>) {
        switch result {
        case .success:
            break
            // TODO: - 리스트 업데이트해서 todoItems.onNext 해야함
        case .failure(let error):
            self.coreDataError.onNext(error.description)
        }
    }
}

