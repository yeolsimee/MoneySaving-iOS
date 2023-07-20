//
//  RoutineNameView.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/31.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class RoutineNameView: UIView {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(imageSet: .routine_Pencil)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = I18NStrings.Routine.name
        label.textColor = .black
        label.font = UIFont.instance(.pretendardBold, size: 15)
        return label
    }()
    
    lazy var nameField: UITextField = {
        let textField = UITextField()
        let attributed = NSAttributedString(string: I18NStrings.Routine.namePlace, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray,
                                                                                                NSAttributedString.Key.font : UIFont.instance(.pretendardRegular, size: 14)])
        
        textField.attributedPlaceholder = attributed
        textField.font = UIFont.instance(.pretendardSemiBold, size: 14)
        textField.textColor = .black
        return textField
    }()
    
    private lazy var underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var fieldRx: Reactive<UITextField> {
        return nameField.rx
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

private extension RoutineNameView {
    func configure() {
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        [imageView,
         nameLabel,
         nameField,
         underLineView].forEach {
            addSubview($0)
        }
    }
    
    func configureConstraints() {
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(23)
            make.centerY.equalTo(nameLabel.snp.centerY)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(imageView.snp.right).offset(5)
            make.right.lessThanOrEqualToSuperview().inset(23)
        }
        
        nameField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(23)
            make.height.equalTo(20)
        }
        
        underLineView.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(23)
            make.height.equalTo(1)
        }
    }
}
