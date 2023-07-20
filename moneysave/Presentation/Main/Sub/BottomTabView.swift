//
//  BottomTabView.swift
//  moneysave
//
//  Created by Mingoo on 2023/04/09.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class BottomTabView: UIView {
    private lazy var btn_Home: UIButton = {
        var config = UIButton.Configuration.plain()
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.instance(.pretendardBold, size: 10)
        titleContainer.foregroundColor = .white
        config.attributedTitle = AttributedString(I18NStrings.Main.home, attributes: titleContainer)
        config.image = UIImage(imageSet: .bottom_01_On)
        config.imagePadding = 5
        config.imagePlacement = .top
        
        let button = UIButton(configuration: config)
        button.tag = 1
        return button
    }()
    
    private lazy var btn_SugRoutine: UIButton = {
        var config = UIButton.Configuration.plain()
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.instance(.pretendardBold, size: 10)
        titleContainer.foregroundColor = .gray
        config.attributedTitle = AttributedString(I18NStrings.Main.sugRoutine, attributes: titleContainer)
        config.image = UIImage(imageSet: .bottom_02_Off)
        config.imagePadding = 5
        config.imagePlacement = .top
        
        let button = UIButton(configuration: config)
        button.tag = 2
        return button
    }()
    
    private lazy var btn_MyPage: UIButton = {
        var config = UIButton.Configuration.plain()
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.instance(.pretendardBold, size: 10)
        titleContainer.foregroundColor = .gray
        config.attributedTitle = AttributedString(I18NStrings.Main.mypage, attributes: titleContainer)
        config.image = UIImage(imageSet: .bottom_03_Off)
        config.imagePadding = 5
        config.imagePlacement = .top
        
        let button = UIButton(configuration: config)
        button.tag = 3
        return button
    }()
    
    private lazy var gap_1: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.tag = 1
        return view
    }()
    
    private lazy var gap_2: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        view.tag = 2
        return view
    }()
    
    private lazy var gap_3: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        view.tag = 3
        return view
    }()
    
    private var btnArray: [UIButton]!
    private var gapArray: [UIView]!
    
    var btn_HomeRx: Reactive<UIButton> {
        return btn_Home.rx
    }
    
    var btn_SugRoutineRx: Reactive<UIButton> {
        return btn_SugRoutine.rx
    }
    
    var btn_MyPageRx: Reactive<UIButton> {
        return btn_MyPage.rx
    }
    
    var gap_Hidden: Int = 0 {
        didSet {
            for i in 0 ..< gapArray.count {
                let gap = gapArray[i]
                let btn = btnArray[i]
                
                if gap_Hidden == gap.tag {
                    
                    gap.isHidden = false
                    btn.configurationUpdateHandler = { button in
                        var config = button.configuration
                        var titleContainer = AttributeContainer()
                        titleContainer.font = UIFont.instance(.pretendardBold, size: 10)
                        titleContainer.foregroundColor = .white
                        config?.attributedTitle = AttributedString((btn.titleLabel?.text)!, attributes: titleContainer)
                        config?.image = UIImage(named: "bottom_0\(gap.tag)_On")
                        button.configuration = config
                    }
                    
                } else {
                    
                    gap.isHidden = true
                    btn.configurationUpdateHandler = { button in
                        var config = button.configuration
                        var titleContainer = AttributeContainer()
                        titleContainer.font = UIFont.instance(.pretendardBold, size: 10)
                        titleContainer.foregroundColor = .gray
                        config?.attributedTitle = AttributedString((btn.titleLabel?.text)!, attributes: titleContainer)
                        config?.image = UIImage(named: "bottom_0\(gap.tag)_Off")
                        button.configuration = config
                    }
                    
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        btnArray = [btn_Home, btn_SugRoutine, btn_MyPage]
        gapArray = [gap_1, gap_2, gap_3]
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension BottomTabView {
    func configure() {
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        self.backgroundColor = .black
        
        [btn_Home,
         btn_SugRoutine,
         btn_MyPage,
         gap_1,
         gap_2,
         gap_3].forEach {
            self.addSubview($0)
        }
    }
    
    func configureConstraints() {
        btn_SugRoutine.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-17)
        }
        
        gap_2.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(btn_SugRoutine.snp.left)
            make.right.equalTo(btn_SugRoutine.snp.right)
            make.height.equalTo(3)
        }
        
        btn_Home.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(52)
            make.bottom.equalToSuperview().offset(-17)
            make.right.lessThanOrEqualTo(btn_SugRoutine.snp.left).inset(20)
        }
        
        gap_1.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(btn_Home.snp.left)
            make.right.equalTo(btn_Home.snp.right)
            make.height.equalTo(3)
        }
        
        btn_MyPage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().inset(52)
            make.bottom.equalToSuperview().offset(-17)
            make.left.greaterThanOrEqualTo(btn_SugRoutine.snp.right).offset(20)
        }
        
        gap_3.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(btn_MyPage.snp.left)
            make.right.equalTo(btn_MyPage.snp.right)
            make.height.equalTo(3)
        }
    }
}
