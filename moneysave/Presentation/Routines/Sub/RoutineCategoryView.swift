//
//  RoutineCategoryView.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/31.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

protocol RoutineCategoryViewProtocol {
    func categoryAddViewState(state: Bool)
    func selectCategoryValue(value: String)
}

final class RoutineCategoryView: UIView {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(imageSet: .routine_Tag)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = I18NStrings.Routine.category
        label.font = UIFont.instance(.pretendardBold, size: 15)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        return collectionView
    }()
    
    var title = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var collectionRx: Reactive<UICollectionView> {
        return collectionView.rx
    }
    
    var contentsHeight: CGFloat {
        return collectionView.contentSize.height
    }
    
    func updateConfigre(height: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
            self?.collectionView.snp.updateConstraints({ make in
                make.height.equalTo(self!.collectionView.collectionViewLayout.collectionViewContentSize)
            })
        }
    }
    
    var delegate: RoutineCategoryViewProtocol?
    var tagArray: [CategoryListData] = []
    var isSelect: String?
    
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

private extension RoutineCategoryView {
    func configure() {
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        [imageView,
         titleLabel,
         collectionView].forEach {
            addSubview($0)
        }
    }
    
    func configureConstraints() {
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(23)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(imageView.snp.right).offset(5)
            make.right.lessThanOrEqualToSuperview().inset(23)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(23)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
}

extension RoutineCategoryView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        let data = tagArray[indexPath.row]
        
        cell.title = data.categoryName
        cell.titleColor = UIColor(colorSet: .Gray_102)!
        cell.borderColor = UIColor(colorSet: .Gray_240)?.cgColor
        cell.backColor = .white
        
        if data.categoryName == "+" {
            cell.backColor = .black
            cell.titleColor = .white
        } else {
            if let select = isSelect, data.categoryName == select {
                cell.borderColor = UIColor.black.cgColor
                cell.titleColor = .black
                cell.backColor = UIColor(colorSet: .Gray_240)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tagLabel: UILabel = {
            let label = UILabel()
            label.text = tagArray[indexPath.row].categoryName
            label.font = UIFont.instance(.pretendardBold, size: 13)
            label.sizeToFit()
            return label
        }()
        
        let size = tagLabel.frame.size
        
        return CGSize(width: size.width + 25, height: size.height + 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        let data = tagArray[indexPath.row]

        if data.categoryName == "+" {
            delegate?.categoryAddViewState(state: true)
        } else {
            isSelect = data.categoryName
            delegate?.selectCategoryValue(value: "\(data.categoryId!)")
            collectionView.reloadData()
        }
    }
}

// UICollectionViewCell 최대한 왼쪽정렬시켜주는 FlowLayout
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.representedElementCategory == .cell {
                
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                
                layoutAttribute.frame.origin.x = leftMargin
                leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                
                maxY = max(layoutAttribute.frame.maxY, maxY)
            }
        }
        
        return attributes
    }
}
