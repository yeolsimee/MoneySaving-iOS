//
//  IntroViewController.swift
//  moneysave
//
//  Created by Bluewave on 2023/03/15.
//

import UIKit
import RxSwift
import RxCocoa

final class IntroViewController: UIViewController {
    let disposeBag: DisposeBag = DisposeBag()
    
    var viewModel: IntroViewModel!
    
    let btn = UIButton()
    let btn_2 = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn.setTitle("테스트", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btn)
        btn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        btn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        btn_2.setTitle("테스트2", for: .normal)
        btn_2.setTitleColor(.white, for: .normal)
        
        btn_2.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btn_2)
        btn_2.topAnchor.constraint(equalTo: btn.bottomAnchor).isActive = true
        btn_2.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        btn_2.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        bind()
    }
}

extension IntroViewController {
    func bind() {
        let input = IntroViewModel.Input(btnEvent: btn.rx.tap.asObservable(),
                                         btn_2Event: btn_2.rx.tap.asObservable())
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
    }
}
