//
//  UIScrollView+RxSwift.swift
//  CleanTodoList
//
//  Created by Apple on 5/28/25.
//

import UIKit
import RxSwift

extension Reactive where Base: UIScrollView {
    
    var bottomReached: Observable<Void> {
        return contentOffset
            .map { offset in
                let scrollView = self.base
                let visibleHeight = scrollView.frame.size.height
                let contentHeight = scrollView.contentSize.height
                let y = offset.y + visibleHeight
                let threshold: CGFloat = 100
                return contentHeight > visibleHeight && y >= contentHeight - threshold
            }
            .distinctUntilChanged()
            .filter { $0 == true }
            .map { _ in }
    }
    
}
