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
    private let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle"), style: .plain, target: nil, action: nil)
    
    private let saveAction: PublishSubject<TodoItem> = PublishSubject<TodoItem>()
    private let readAction: PublishSubject<Void> = PublishSubject<Void>()
    private let updateAction: PublishSubject<TodoItem> = PublishSubject<TodoItem>()
    private let deleteAction: PublishSubject<TodoItem> = PublishSubject<TodoItem>()
    private let filterAction: PublishSubject<FilterType> = PublishSubject<FilterType>()
    private let refreshAction: PublishSubject<Void> = PublishSubject<Void>()
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
        setAction()
        setBinding()
    }
    
    private func setUI() {
        navigationItem.rightBarButtonItems = [addButton, filterButton]
        todoListView.placeholderView.isHidden = true
        todoListView.tableView.refreshControl = todoListView.refreshControl
        todoListView.tableView.register(TodoListViewCell.self, forCellReuseIdentifier: "TodoListCell")
        todoListView.tableView.tableFooterView = todoListView.bottomView
        todoListView.tableView.tableFooterView?.isHidden = true
        todoListView.tableView.rowHeight = UITableView.automaticDimension
        todoListView.tableView.estimatedRowHeight = 100
    }
    
    private func setAction() {
        addButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.addButtonTapped()
            }.disposed(by: disposeBag)
        
        filterButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.showFilterView()
                self.todoListView.tableView.tableFooterView?.isHidden = true
            }.disposed(by: disposeBag)
        
        todoListView.refreshControl.rx.controlEvent(.valueChanged)
            .bind { [weak self] in
                guard let self = self else { return }
                self.refreshAction.onNext(())
            }.disposed(by: disposeBag)
        
        todoListView.tableView.rx.bottomReached
            .skip(1)
            .throttle(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.readAction.onNext(())
            }).disposed(by: disposeBag)
        
        todoListView.tableView.rx.modelSelected(TodoItem.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] selectedItem in
                guard let self = self else { return }
                self.todoItemTapped(item: selectedItem)
            }).disposed(by: disposeBag)
        
        todoListView.tableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                guard let item = try? self.todoListView.tableView.rx.model(at: indexPath) as TodoItem else { return }
                self.deleteAction.onNext(item)
            }).disposed(by: disposeBag)
        
    }
    
    private func setBinding() {
        let input = TodoViewModel.Input(saveAction: saveAction,
                                        readAction: readAction,
                                        updateAction: updateAction,
                                        deleteAction: deleteAction,
                                        filterAction: filterAction,
                                        refreshAction: refreshAction)
        
        let output = todoViewModel.transform(input: input)
        
        output.todoItems
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] items in
                guard let self = self else { return }
                self.todoListView.placeholderView.isHidden = !items.isEmpty
                if self.todoListView.refreshControl.isRefreshing {
                    self.todoListView.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
        
        output.todoItems
            .observe(on: MainScheduler.instance)
            .bind(to: todoListView.tableView.rx.items(cellIdentifier: "TodoListCell", cellType: TodoListViewCell.self)) { index, item, cell in
                cell.configure(item: item)
                cell.switchChangedEvent
                    .subscribe(onNext: { [weak self] isOn in
                        guard let self = self else { return }
                        var updatedItem = item
                        updatedItem.done = isOn
                        self.updateAction.onNext(updatedItem)
                    })
                    .disposed(by: cell.disposeBag)
            }.disposed(by: disposeBag)
        
        output.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] bool in
                guard let self = self else { return }
                bool ? self.todoListView.indicatorView.startAnimating() : self.todoListView.indicatorView.stopAnimating()
            }.disposed(by: disposeBag)
        
        output.noMoreData
            .observe(on: MainScheduler.instance)
            .bind { [weak self] bool in
                guard let self = self else { return }
                self.todoListView.tableView.tableFooterView?.isHidden = bool ? false : true
            }.disposed(by: disposeBag)
        
        output.coreDataError
            .observe(on: MainScheduler.instance)
            .bind { [weak self] errorMsg in
                guard let self = self else { return }
                self.showAlert(message: errorMsg)
            }.disposed(by: disposeBag)
    }
    
    
    private func showFilterView() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let allAction = UIAlertAction(title: "전체", style: .default) { _ in
            self.filterAction.onNext(.all)
            self.navigationItem.rightBarButtonItems = [self.addButton, self.filterButton]
        }
        
        let doneAction = UIAlertAction(title: "완료", style: .default) { _ in
            self.filterAction.onNext(.done)
            self.navigationItem.rightBarButtonItems = [self.filterButton]
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(allAction)
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    private func addButtonTapped() {
        let alert = UIAlertController(title: "할 일 추가", message: "추가할 내용을 입력하세요.", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "확인", style: .default) { _ in
            if let text = alert.textFields?.first?.text, !text.isEmpty {
                let item = TodoItem(uuid: UUID(), title: text, done: false, date: Date())
                self.saveAction.onNext((item))
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addTextField()
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func todoItemTapped(item: TodoItem) {
        let alert = UIAlertController(title: "할 일 수정", message: "내용을 수정하세요.", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = item.title
        }
        
        let saveAction = UIAlertAction(title: "확인", style: .default) { _ in
            if let updatedText = alert.textFields?.first?.text, !updatedText.isEmpty {
                var updatedItem = item
                if updatedText != item.title {
                    updatedItem.title = updatedText
                    updatedItem.date = Date()
                }
                self.updateAction.onNext(updatedItem)
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

