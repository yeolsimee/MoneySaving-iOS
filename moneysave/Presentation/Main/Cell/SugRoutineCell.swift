//
//  SugRoutineCell.swift
//  moneysave
//
//  Created by Mingoo on 2023/04/10.
//

import UIKit
import SnapKit

class SugRoutineCell: UICollectionViewCell {
    private lazy var contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(imageSet: .sug_Update)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = I18NStrings.Sug.title
        label.font = UIFont.instance(.pretendardExtraBold, size: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subLabel: UILabel = {
        let label = UILabel()
        label.text = I18NStrings.Sug.sub
        label.font = UIFont.instance(.pretendardBold, size: 14)
        label.textColor = UIColor(colorSet: .Gray_102)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("SugRoutineCell Not implemented required init?(coder: NSCoder)")
    }
}

extension SugRoutineCell {
    func configure() {
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        self.addSubview(contentsView)
        
        [imageView,
         titleLabel,
         subLabel].forEach {
            contentsView.addSubview($0)
        }
    }
    
    func configureConstraints() {
        contentsView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(22)
            make.centerY.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(13)
            make.left.right.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
