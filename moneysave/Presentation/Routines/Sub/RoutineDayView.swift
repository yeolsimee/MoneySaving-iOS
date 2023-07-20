//
//  RoutineDayView.swift
//  moneysave
//
//  Created by Mingoo on 2023/04/26.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

protocol RoutineDayViewProtocol {
    func selectDayValue(value: [String])
}

final class RoutineDayView: UIView {
    private lazy var titleView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(imageSet: .routine_Refresh)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = I18NStrings.Routine.repeat
        label.font = UIFont.instance(.pretendardBold, size: 15)
        return label
    }()
    
    private lazy var btnStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var btn_Mon: UIButton = {
        let button = UIButton()
        button.setTitle("월", for: .normal)
        button.setTitleColor(UIColor(colorSet: .Gray_102), for: .normal)
        button.titleLabel?.font = UIFont.instance(.pretendardMedium, size: 13)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(colorSet: .Gray_153)?.cgColor
        button.addTarget(self, action: #selector(dayAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var btn_Tue: UIButton = {
        let button = UIButton()
        button.setTitle("화", for: .normal)
        button.setTitleColor(UIColor(colorSet: .Gray_102), for: .normal)
        button.titleLabel?.font = UIFont.instance(.pretendardMedium, size: 13)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(colorSet: .Gray_153)?.cgColor
        button.addTarget(self, action: #selector(dayAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var btn_Wed: UIButton = {
        let button = UIButton()
        button.setTitle("수", for: .normal)
        button.setTitleColor(UIColor(colorSet: .Gray_102), for: .normal)
        button.titleLabel?.font = UIFont.instance(.pretendardMedium, size: 13)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(colorSet: .Gray_153)?.cgColor
        button.addTarget(self, action: #selector(dayAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var btn_Thu: UIButton = {
        let button = UIButton()
        button.setTitle("목", for: .normal)
        button.setTitleColor(UIColor(colorSet: .Gray_102), for: .normal)
        button.titleLabel?.font = UIFont.instance(.pretendardMedium, size: 13)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(colorSet: .Gray_153)?.cgColor
        button.addTarget(self, action: #selector(dayAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var btn_Fri: UIButton = {
        let button = UIButton()
        button.setTitle("금", for: .normal)
        button.setTitleColor(UIColor(colorSet: .Gray_102), for: .normal)
        button.titleLabel?.font = UIFont.instance(.pretendardMedium, size: 13)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(colorSet: .Gray_153)?.cgColor
        button.addTarget(self, action: #selector(dayAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var btn_Sat: UIButton = {
        let button = UIButton()
        button.setTitle("토", for: .normal)
        button.setTitleColor(UIColor(colorSet: .Gray_102), for: .normal)
        button.titleLabel?.font = UIFont.instance(.pretendardMedium, size: 13)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(colorSet: .Gray_153)?.cgColor
        button.addTarget(self, action: #selector(dayAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var btn_Sun: UIButton = {
        let button = UIButton()
        button.setTitle("일", for: .normal)
        button.setTitleColor(UIColor(colorSet: .Gray_102), for: .normal)
        button.titleLabel?.font = UIFont.instance(.pretendardMedium, size: 13)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(colorSet: .Gray_153)?.cgColor
        button.addTarget(self, action: #selector(dayAction(_:)), for: .touchUpInside)
        return button
    }()
    
    var delegate: RoutineDayViewProtocol?
    var btnArray: [UIButton]!
    var selectArray: [String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        
        btnArray = [btn_Mon, btn_Tue, btn_Wed, btn_Thu, btn_Fri, btn_Sat, btn_Sun]
        
        btnDayEvent(sender: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension RoutineDayView {
    func configure() {
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        [titleView,
         btnStackView].forEach {
            addSubview($0)
        }
        
        [imageView,
         titleLabel].forEach {
            titleView.addSubview($0)
        }
        
        [btn_Mon,
         btn_Tue,
         btn_Wed,
         btn_Thu,
         btn_Fri,
         btn_Sat,
         btn_Sun].forEach {
            btnStackView.addArrangedSubview($0)
        }
    }
    
    func configureConstraints() {
        titleView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(23)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(imageView.snp.right).offset(5)
            make.right.lessThanOrEqualToSuperview()
        }
        
        btnStackView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(23)
            make.bottom.equalToSuperview()
        }
    }
    
    func btnDayEvent(sender: UIButton?) {
        if let sender = sender {
            for i in btnArray {
                if sender.titleLabel?.text == i.titleLabel?.text {
                    sender.isSelected = !sender.isSelected
                    let font: UIFont = sender.isSelected ? UIFont.instance(.pretendardSemiBold, size: 13) : UIFont.instance(.pretendardMedium, size: 13)
                    let textColor: UIColor = sender.isSelected ? .black : UIColor(colorSet: .Gray_102)!
                    let backColor: UIColor = sender.isSelected ? UIColor(colorSet: .Gray_240)! : .white
                    let layerColor: CGColor = sender.isSelected ? UIColor.black.cgColor : UIColor(colorSet: .Gray_153)!.cgColor
                    let state: UIControl.State = sender.isSelected ? .selected : .normal
                    
                    sender.titleLabel?.font = font
                    sender.setTitleColor(textColor, for: state)
                    sender.backgroundColor = backColor
                    sender.layer.borderColor = layerColor
                    
                    if sender.isSelected {
                        selectArray.append(sender.titleLabel!.text!.toWeekEn())
                    } else {
                        selectArray = selectArray.filter { $0 != sender.titleLabel!.text!.toWeekEn() }
                    }
                }
            }
        } else {
            // 첫 진입 시 셀렉트 여부 확인
            if selectArray.count > 0 {
                for i in selectArray {
                    print("1452 i : \(i)")
                    let btn = btnArray.filter { $0.titleLabel?.text == i.toWeekKo() }[0]
                    btn.isSelected = true
                    btn.titleLabel?.font = UIFont.instance(.pretendardSemiBold, size: 13)
                    btn.setTitleColor(.black, for: .selected)
                    btn.backgroundColor = UIColor(colorSet: .Gray_240)
                    btn.layer.borderColor = UIColor.black.cgColor
                }
            }
        }
        
        delegate?.selectDayValue(value: selectArray)
    }
    
    @objc func dayAction(_ sender: UIButton) {
        btnDayEvent(sender: sender)
    }
}
