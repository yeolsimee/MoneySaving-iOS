//
//  RoutineCellDummyView.swift
//  moneysave
//
//  Created by Mingoo on 2023/06/22.
//

import UIKit
import SnapKit

final class RoutineCellDummyView: UIView {
    lazy var roundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(colorSet: .Gray_153)?.cgColor
        return view
    }()
    
    lazy var btn_Check: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(imageSet: .routine_NonCheck), for: .normal)
        return button
    }()
    
    lazy var labelView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.instance(.pretendardExtraBold, size: 15)
        label.textColor = UIColor(colorSet: .Gray_153)
        return label
    }()
    
    lazy var timeView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var timeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(imageSet: .routine_Time)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "TimeLabel Test"
        label.font = UIFont.instance(.pretendardMedium, size: 11)
        label.textColor = UIColor(colorSet: .Gray_153)
        return label
    }()
    
    lazy var alamView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var alamImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(imageSet: .routine_Alarm)
        return imageView
    }()
    
    lazy var alamLabel: UILabel = {
        let label = UILabel()
        label.text = "AlamLabel Test"
        label.font = UIFont.instance(.pretendardMedium, size: 11)
        label.textColor = UIColor(colorSet: .Gray_153)
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    lazy var btn_Content: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension RoutineCellDummyView {
    func configure() {
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        self.addSubview(roundView)

        [timeImageView,
         timeLabel].forEach {
            timeView.addSubview($0)
        }
        
        [alamImageView,
         alamLabel].forEach {
            alamView.addSubview($0)
        }
        
        [timeView,
         alamView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [titleLabel,
         stackView].forEach {
            labelView.addSubview($0)
        }
        
        [labelView,
         btn_Content,
         btn_Check].forEach {
            roundView.addSubview($0)
        }
    }
    
    func configureConstraints() {
        roundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.left.right.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(4)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
        }
        
        timeImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(timeLabel.snp.left).offset(-8)
            make.centerY.equalTo(timeLabel.snp.centerY)
        }
        
        alamLabel.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
        }

        alamImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(alamLabel.snp.left).offset(-8)
            make.centerY.equalTo(alamLabel.snp.centerY)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.bottom.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
        
        labelView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.left.equalToSuperview().offset(20)
        }
        
        btn_Check.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.left.equalTo(labelView.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(labelView.snp.width).multipliedBy(0.3)
        }
        
        btn_Content.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.right.equalTo(btn_Check.snp.left)
        }
    }
}
