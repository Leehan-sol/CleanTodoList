//
//  DoneListView.swift
//  CleanTodoList
//
//  Created by Apple on 5/21/25.
//

import UIKit
import SnapKit

class DoneListView: UIView {
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
        backgroundColor = .systemPink
    }
    
}
