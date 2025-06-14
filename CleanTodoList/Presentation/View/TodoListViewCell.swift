//
//  TodoListViewCell.swift
//  CleanTodoList
//
//  Created by hansol on 2025/06/03.
//

import UIKit
import RxSwift
import RxCocoa

class TodoListViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        return label
    }()
    
    let doneSwitch: UISwitch = {
        let doneSwitch = UISwitch()
        return doneSwitch
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "작성일"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let switchChangedEvent: PublishSubject<Bool> = PublishSubject<Bool>()
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setBinding()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        setBinding()
    }
    
    private func setUI() {
        let subviews = [titleLabel, doneSwitch, dateLabel]
        
        subviews.forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        doneSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.bottom.equalToSuperview().offset(-5)
        }
    }
    
    func configure(item: TodoItem) {
        titleLabel.text = item.title
        doneSwitch.isOn = item.done
        dateLabel.text = item.date.toDisplayString()
    }
    
    private func setBinding() {
        doneSwitch.rx.isOnChanged
            .subscribe(onNext: { [weak self] isOn in
                guard let self = self else { return }
                switchChangedEvent.onNext(isOn)
            }).disposed(by: disposeBag)
    }
    
}
