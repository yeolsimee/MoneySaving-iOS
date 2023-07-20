//
//  CategoryListCell.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/12.
//

import UIKit
import SnapKit

protocol CategoryListCellProtocol {
    func categoryNameEdit(name: String, id: String)
}

class CategoryListCell: UITableViewCell {
    var delegate: CategoryListCellProtocol?
    
    lazy var roundView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor(colorSet: .Gray_240)?.cgColor
        view.layer.cornerRadius = 4
        return view
    }()
    
    lazy var textField: UITextField = {
        let field = UITextField()
        field.delegate = self
        field.font = UIFont.instance(.pretendardBold, size: 15)
        field.textAlignment = .left
        return field
    }()
    
    var data: CategoryListData?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension CategoryListCell {
    func configure() {
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        contentView.addSubview(roundView)
        
        roundView.addSubview(textField)
    }
    
    func configureConstraints() {
        roundView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }
        
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
}

extension CategoryListCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let name = data?.categoryName, name != textField.text {
            delegate?.categoryNameEdit(name: textField.text ?? "", id: data?.categoryId ?? "")
        }
    }
}
