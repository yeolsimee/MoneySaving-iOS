//
//  RoutineAlarmView.swift
//  moneysave
//
//  Created by Mingoo on 2023/04/27.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class RoutineAlarmView: UIView {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var titleView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(imageSet: .routine_Alarm_2)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = I18NStrings.Routine.alarm
        label.font = UIFont.instance(.pretendardBold, size: 15)
        label.textAlignment = .left
        return label
    }()
    
    lazy var `switch`: UISwitch = {
        let `switch` = UISwitch()
        `switch`.tintColor = .white
        `switch`.onTintColor = .black
        return `switch`
    }()
    
    private lazy var opstionView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = I18NStrings.Routine.alarmSub
        label.font = UIFont.instance(.pretendardSemiBold, size: 13)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var timeView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(colorSet: .Gray_240)?.cgColor
        view.layer.cornerRadius = 4
        return view
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "오전 00:00"
        label.font = UIFont.instance(.pretendardMedium, size: 12)
        label.textColor = .black
        return label
    }()
    
    private lazy var btn_Time: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var opstionViewState: Bool = true {
        didSet {
            opstionView.isHidden = opstionViewState
        }
    }
    
    var toggleRx: Reactive<UISwitch> {
        return `switch`.rx
    }
    
    var timeRx: Reactive<UIButton> {
        return btn_Time.rx
    }
    
    var alarmDateText: String = "" {
        didSet {
            timeLabel.text = alarmDateText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension RoutineAlarmView {
    func configure() {
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        [stackView].forEach {
            addSubview($0)
        }
        
        [titleView,
         opstionView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [imageView,
         titleLabel,
         `switch`].forEach {
            titleView.addSubview($0)
        }
        
        [subTitleLabel,
         timeView].forEach {
            opstionView.addSubview($0)
        }
        
        [timeLabel,
         btn_Time].forEach {
            timeView.addSubview($0)
        }
    }
    
    func configureConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(23)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(imageView.snp.right).offset(5)
            make.right.lessThanOrEqualTo(`switch`.snp.right).offset(20)
            make.bottom.equalToSuperview()
        }
        
        `switch`.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.right.equalToSuperview().inset(23)
            make.height.equalTo(titleLabel.snp.height)
        }
        
        timeView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-23)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(timeView.snp.centerY)
            make.left.equalToSuperview().offset(23)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(10)
        }
        
        btn_Time.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
