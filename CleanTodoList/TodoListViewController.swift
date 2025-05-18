//
//  ViewController.swift
//  CleanTodoList
//
//  Created by hansol on 2025/05/18.
//

import UIKit
import SnapKit

class TodoListViewController: UIViewController {

    let todoListView = TodoListView()
    
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

