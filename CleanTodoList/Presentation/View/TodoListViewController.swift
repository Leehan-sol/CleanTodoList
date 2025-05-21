//
//  ViewController.swift
//  CleanTodoList
//
//  Created by hansol on 2025/05/18.
//

import UIKit
import SnapKit

class TodoListViewController: UIViewController {

    private let todoListView: TodoListView
    private let todoViewModel: TodoViewModelProtocol
    
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
    }

    func setUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
             barButtonSystemItem: .add,
             target: self,
             action: #selector(addButtonTapped)
         )
    }
    
    @objc func addButtonTapped() {
        
    }

}

