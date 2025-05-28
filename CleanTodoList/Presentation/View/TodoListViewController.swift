//
//  ViewController.swift
//  CleanTodoList
//
//  Created by hansol on 2025/05/18.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TodoListViewController: UIViewController {
    
    private let todoListView: TodoListView
    private let todoViewModel: TodoViewModelProtocol
    private let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    
    private let saveAction: PublishSubject<TodoItem> = PublishSubject<TodoItem>()
    private let readAction: PublishSubject<Void> = PublishSubject<Void>()
    private let updateAction: PublishSubject<TodoItem> = PublishSubject<TodoItem>()
    private let deleteAction: PublishSubject<TodoItem> = PublishSubject<TodoItem>()
    private let disposeBag = DisposeBag()
    
    init(todoListView: TodoListView, todoViewModel: TodoViewModelProtocol) {
        self.todoListView = todoListView
        self.todoViewModel = todoViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = todoListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setGesture()
        setAction()
        setBinding()
    }
    
    func setUI() {
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setGesture() {
    
    }
    
    private func setAction() {
        addButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.addButtonTapped()
            }
            .disposed(by: disposeBag)
        
        todoListView.tableView.rx.bottomReached
            .skip(1)
            .throttle(RxTimeInterval.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.readAction.onNext(())
            }).disposed(by: disposeBag)
        
        // TODO: - 1) 뷰컨 액션 정의
        // 테이블뷰 셀 누르면 updateAction.onNext - 해당 할일 전달, 데이터 업데이트
        // 테이블뷰 왼쪽으로 드래그시 휴지통 버튼 표시, deleteAction onNext - 해당 할일 전달, 삭제

        
        //        listView.listTableView.rx.itemSelected
        //            .subscribe(onNext: { [weak self] indexPath in
        //                self?.listView.listTableView.deselectRow(at: indexPath, animated: true)
        //                self?.saveReadNewsAction.onNext(indexPath.row)
        //            }).disposed(by: disposeBag)
    }
    
    private func setBinding() {
        // TODO: - 3) 뷰모델에서 state 받아서 뷰에 바인딩 하기
        let input = TodoViewModel.Input(saveAction: saveAction, readAction: readAction, updateAction: updateAction, deleteAction: deleteAction)
        
        let output = todoViewModel.transform(input: input)
        
        output.todoItems
            .bind { [weak self] todoItems in
                guard let self = self else { return }
            }
            .disposed(by: disposeBag)
        
        output.isLoading
            .bind { [weak self] isLoading in
                guard let self = self else { return }
            }
            .disposed(by: disposeBag)
        
        output.noMoreData
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.todoListView.tableView.tableFooterView?.isHidden = false
            }
            .disposed(by: disposeBag)
        
        output.coreDataError
            .bind { [weak self] errorMsg in
                guard let self = self else { return }
            }
            .disposed(by: disposeBag)
        
        output.refreshTrigger
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.todoListView.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func addButtonTapped() {
        let alertController = UIAlertController(title: "할 일 추가", message: "추가할 내용을 입력하세요.", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "추가", style: .default) { _ in
            if let text = alertController.textFields?.first?.text, !text.isEmpty {
                let item = TodoItem(uuid: UUID(), title: text, done: false)
                self.saveAction.onNext((item))
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addTextField()
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}

