//
//  MainViewController.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/26.
//

import UIKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    let disposeBag: DisposeBag = DisposeBag()
    
    var viewModel: MainViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
