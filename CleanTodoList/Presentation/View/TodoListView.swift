//
//  TodoView.swift
//  CleanTodoList
//
//  Created by hansol on 2025/05/18.
//

import UIKit
import SnapKit

class TodoListView: UIView {
    
    // MARK: - UI Components
    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect){
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Method
    private func setUI(){
        backgroundColor = .systemBackground
        
        addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-80)
        }
        
    
    }
}

