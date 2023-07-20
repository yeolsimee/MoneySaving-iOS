//
//  RoutineTimeView.swift
//  moneysave
//
//  Created by Mingoo on 2023/04/26.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

protocol RoutineTimeViewProtocol  {
    func selectTimeValue(value: String)
}

final class RoutineTimeView: UIView {
    private lazy var titleView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(imageSet: .routine_Time_2)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = I18NStrings.Routine.time
        label.font = UIFont.instance(.pretendardBold, size: 15)
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TimeCell.self, forCellWithReuseIdentifier: "TimeCell")
        return collectionView
    }()
    
    var collectionRx: Reactive<UICollectionView> {
        return collectionView.rx
    }
    
    var contentsHeight: CGFloat {
        return collectionView.contentSize.height
    }
    
    func updateConfigre(height: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.snp.updateConstraints({ make in
                make.height.equalTo(height)
            })
        }
    }
    
    var delegate: RoutineTimeViewProtocol?
    var tagArray = ["하루종일", "아무때나", "아침", "점심", "저녁", "밤", "취침직전", "기상직후", "오전", "오후"]
    var selectTag: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension RoutineTimeView {
    func configure() {
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        [titleView,
         collectionView].forEach {
            addSubview($0)
        }
        
        [imageView,
         titleLabel].forEach {
            titleView.addSubview($0)
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
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(23)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
}

extension RoutineTimeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCell", for: indexPath) as! TimeCell
        let data = tagArray[indexPath.row]
        
        cell.title = data
        cell.backColor = .white
        cell.borderColor = UIColor(colorSet: .Gray_240)?.cgColor
        cell.titleFont = UIFont.instance(.pretendardMedium, size: 13)
        cell.titleColor = UIColor(colorSet: .Gray_102)
        
        if let tag = selectTag, tag == data {
            cell.backColor = UIColor(colorSet: .Gray_240)
            cell.borderColor = UIColor.black.cgColor
            cell.titleFont = UIFont.instance(.pretendardSemiBold, size: 13)
            cell.titleColor = .black
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tagLabel: UILabel = {
            let label = UILabel()
            label.text = tagArray[indexPath.item]
            label.font = UIFont.instance(.pretendardMedium, size: 13)
            label.sizeToFit()
            return label
        }()
        
        let size = tagLabel.frame.size
        
        return CGSize(width: size.width + 25, height: size.height + 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = tagArray[indexPath.row]
        selectTag = "\(data)"
        delegate?.selectTimeValue(value: "\(data.toTimeZoneInt())")
        collectionView.reloadData()
    }
}
