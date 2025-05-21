//
//  TodoViewModel.swift
//  CleanTodoList
//
//  Created by Apple on 5/21/25.
//

import Foundation

protocol TodoViewModelProtocol {
    
}

class TodoViewModel: TodoViewModelProtocol {
    private let useCase: TodoUseCase
    
    init(useCase: TodoUseCase) {
        self.useCase = useCase
    }
    
    
    // TODO: - 뷰에서 Action 받음 -> UseCase의 로직 실행 -> State 반환
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
    
}

