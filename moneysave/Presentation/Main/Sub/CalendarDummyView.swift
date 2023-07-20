//
//  CalendarDummyView.swift
//  moneysave
//
//  Created by Mingoo on 2023/04/15.
//

import UIKit
import SnapKit

final class CalendarDummyView: UIView {
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "31"
        label.font = UIFont.instance(.pretendardMedium, size: 10)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(imageSet: .calendar_today)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var underView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension CalendarDummyView {
    func configure() {
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        [dateLabel,
         imageView,
         underView].forEach {
            addSubview($0)
        }
    }
    
    func configureConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.right.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
        }
        
        underView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.width.equalTo(imageView.snp.width).multipliedBy(0.5)
            make.height.equalTo(2)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
