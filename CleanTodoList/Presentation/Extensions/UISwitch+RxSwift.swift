//
//  UISwitch+RxSwift.swift
//  CleanTodoList
//
//  Created by hansol on 2025/06/03.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UISwitch {
    var isOnChanged: ControlEvent<Bool> {
         let source = controlEvent(.valueChanged)
             .map { self.base.isOn }
         return ControlEvent(events: source)
     }
}
