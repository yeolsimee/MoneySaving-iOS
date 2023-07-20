//
//  DayLabelView.swift
//  moneysave
//
//  Created by Mingoo on 2023/04/11.
//

import UIKit
import SnapKit

final class DayLabelView: UIView {
    private lazy var monLabel: UILabel = {
        let label = UILabel()
        label.text = "월"
        label.font = UIFont.instance(.pretendardBold, size: 12)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tuesLabel: UILabel = {
        let label = UILabel()
        label.text = "화"
        label.font = UIFont.instance(.pretendardBold, size: 12)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var wednesLabel: UILabel = {
        let label = UILabel()
        label.text = "수"
        label.font = UIFont.instance(.pretendardBold, size: 12)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var thursLabel: UILabel = {
        let label = UILabel()
        label.text = "목"
        label.font = UIFont.instance(.pretendardBold, size: 12)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var friLabel: UILabel = {
        let label = UILabel()
        label.text = "금"
        label.font = UIFont.instance(.pretendardBold, size: 12)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var saturLabel: UILabel = {
        let label = UILabel()
        label.text = "토"
        label.font = UIFont.instance(.pretendardBold, size: 12)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var sunLabel: UILabel = {
        let label = UILabel()
        label.text = "일"
        label.font = UIFont.instance(.pretendardBold, size: 12)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
//        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension DayLabelView {
    func configure() {
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        self.backgroundColor = .white
        
        self.addSubview(stackView)
        
        [monLabel,
         tuesLabel,
         wednesLabel,
         thursLabel,
         friLabel,
         saturLabel,
         sunLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    func configureConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tuesLabel.snp.makeConstraints { make in
            make.width.equalTo(monLabel).multipliedBy(1)
        }
        
        wednesLabel.snp.makeConstraints { make in
            make.width.equalTo(monLabel).multipliedBy(1)
        }
        
        thursLabel.snp.makeConstraints { make in
            make.width.equalTo(monLabel).multipliedBy(1)
        }
        
        friLabel.snp.makeConstraints { make in
            make.width.equalTo(monLabel).multipliedBy(1)
        }
        
        saturLabel.snp.makeConstraints { make in
            make.width.equalTo(monLabel).multipliedBy(1)
        }
        
        sunLabel.snp.makeConstraints { make in
            make.width.equalTo(monLabel).multipliedBy(1)
        }
    }
}
