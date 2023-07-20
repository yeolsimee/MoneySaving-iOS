//
//  CalendarCell.swift
//  moneysave
//
//  Created by Mingoo on 2023/04/10.
//

import UIKit
import SnapKit
import JTAppleCalendar

final class CalendarCell: JTACDayCell {
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.instance(.pretendardMedium, size: 10)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var underView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var title = "" {
        didSet {
            dateLabel.text = title
        }
    }
    
    var textColor: UIColor? {
        didSet {
            dateLabel.textColor = textColor
        }
    }
    
    var textFont: UIFont? {
        didSet {
            dateLabel.font = textFont
        }
    }
    
    var img: UIImage? {
        didSet {
            imageView.image = img
        }
    }
    
    var underHidden: Bool = true {
        didSet {
            underView.isHidden = underHidden
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Func
extension CalendarCell {
    func configure() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(underView)
        
        underView.isHidden = true
        
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
        }
    }
}
