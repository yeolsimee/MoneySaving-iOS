//
//  DateSelectView.swift
//  moneysave
//
//  Created by Mingoo on 2023/04/16.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class DateSelectView: UIView {
    private lazy var contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "dateLabel"
        label.textColor = .black
        label.font = UIFont.instance(.pretendardSemiBold, size: 16)
        label.textAlignment = .left
        return label
    }()
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    private lazy var btn_Cancel: UIButton = {
        let button = UIButton()
        button.setTitle(I18NStrings.cancel, for: .normal)
        button.setTitleColor(.gray, for: .normal)
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
    
    var dateText: String = "" {
        didSet {
            dateLabel.text = dateText
        }
    }
    
    var cancelRx: Reactive<UIButton> {
        return btn_Cancel.rx
    }
    
    var confirmRx: Reactive<UIButton> {
        return btn_Confirm.rx
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

private extension DateSelectView {
    func configure() {
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        self.backgroundColor = UIColor(colorSet: .Dim)
        
        self.addSubview(contentsView)
        
        [dateLabel,
         pickerView,
         btn_Confirm,
         btn_Cancel].forEach {
            contentsView.addSubview($0)
        }
    }
    
    func configureConstraints() {
        contentsView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().offset(20)
        }
        
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
        }
        
        btn_Confirm.snp.makeConstraints { make in
            make.top.equalTo(pickerView.snp.bottom).offset(16)
            make.right.bottom.equalToSuperview().inset(20)
        }
        
        btn_Cancel.snp.makeConstraints { make in
            make.top.equalTo(btn_Confirm.snp.top)
            make.left.greaterThanOrEqualToSuperview()
            make.right.equalTo(btn_Confirm.snp.left).offset(-16)
        }
    }
}
