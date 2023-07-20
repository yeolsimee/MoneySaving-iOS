//
//  RoutineDatePickerView.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/08.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class RoutineDatePickerView: UIView {
    var selectDate: Date?
    
    private lazy var contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        return view
    }()
    
    private lazy var pickerView: UIDatePicker = {
        let pickerView = UIDatePicker()
        pickerView.locale = Locale(identifier: "ko_KR")
        pickerView.timeZone = TimeZone(abbreviation: "KST")
        pickerView.preferredDatePickerStyle = .wheels
        pickerView.datePickerMode = .time
        pickerView.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
        return pickerView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var btn_Cancel: UIButton = {
        let button = UIButton()
        button.setTitle(I18NStrings.cancel, for: .normal)
        button.setTitleColor(UIColor(colorSet: .Gray_102), for: .normal)
        button.titleLabel?.font = UIFont.instance(.pretendardRegular, size: 14)
        return button
    }()
    
    private lazy var btn_Confirm: UIButton = {
        let button = UIButton()
        button.setTitle(I18NStrings.confirm, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.instance(.pretendardMedium, size: 14)
        return button
    }()
    
    var viewState: Bool = true {
        didSet {
            self.isHidden = viewState
            
            if !viewState && selectDate == nil {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "ko_KR")
                dateFormatter.timeZone = TimeZone(abbreviation: "KST")
                dateFormatter.dateFormat = "a HH:mm"
                selectDate = Date()
            }
        }
    }
    
    var cancelRx: Reactive<UIButton> {
        return btn_Cancel.rx
    }
    
    var confirmRx: Reactive<UIButton> {
        return btn_Confirm.rx
    }
    
    var dateSelectValue: Date? {
        return selectDate
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        
        backgroundColor = UIColor(colorSet: .Dim)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension RoutineDatePickerView {
    func configure() {
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        addSubview(contentsView)
        
        [pickerView,
         stackView].forEach {
            contentsView.addSubview($0)
        }
        
        [btn_Cancel,
         btn_Confirm].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    func configureConstraints() {
        contentsView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(70)
        }
        
        pickerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.left.right.equalToSuperview().inset(50)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(pickerView.snp.bottom).offset(16)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "a HH:mm"
        selectDate = sender.date
    }
}
