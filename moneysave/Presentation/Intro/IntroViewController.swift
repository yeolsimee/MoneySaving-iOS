//
//  IntroViewController.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/15.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class IntroViewController: UIViewController {
    // MARK: - View Property
    private lazy var statusView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(imageSet: .splash)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let disposeBag: DisposeBag = DisposeBag()
    
    var viewModel: IntroViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
}

extension IntroViewController {
    func bind() {
        let input = IntroViewModel.Input(viewDidLoadEvent: Observable.just(()))
        
        let _ = viewModel.transform(from: input, disposeBag: disposeBag)
    }
    
    func configure() {
        view.backgroundColor = .white
        self.setupToHideKeyboardOnTapOnView()
        
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        [statusView,
         contentsView].forEach {
            view.addSubview($0)
        }
        
        contentsView.addSubview(imageView)
    }
    
    func configureConstraints() {
        statusView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(UIApplication.shared.statusBarHeight)
        }
        
        contentsView.snp.makeConstraints { make in
            make.top.equalTo(statusView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
