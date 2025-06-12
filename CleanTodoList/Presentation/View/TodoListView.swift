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
    
    let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        return indicator
    }()
    
    let refreshControl = UIRefreshControl()
    
    let bottomView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        let label = UILabel()
        label.text = "더이상 데이터가 없습니다."
        view.backgroundColor = .systemGray6
        view.addSubview(label)
        
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        return view
    }()
    
    let placeholderView: UIView = {
        let view = UIView()
        let label = UILabel()
        label.text = "저장된 할 일이 없습니다."
        view.addSubview(label)
        
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        return view
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
        
        let subviews = [tableView, indicatorView, placeholderView]
        subviews.forEach { self.addSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        indicatorView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        placeholderView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
    }
}

