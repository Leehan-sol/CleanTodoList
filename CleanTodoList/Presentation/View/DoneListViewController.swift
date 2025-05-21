//
//  DoneListViewController.swift
//  CleanTodoList
//
//  Created by hansol on 2025/05/18.
//

import UIKit

class DoneListViewController: UIViewController {
    
    private let doneListView: DoneListView
    private let todoViewModel: TodoViewModelProtocol
    
    init(doneListView: DoneListView, todoViewModel: TodoViewModelProtocol) {
        self.doneListView = doneListView
        self.todoViewModel = todoViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = doneListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
