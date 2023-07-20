//
//  CategoryListViewController.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/20.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class CategoryListViewController: UIViewController {
    private lazy var statusView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var btn_NavigationBar: NavigationBarView = {
        let view = NavigationBarView()
        view.title = I18NStrings.MyPage.category
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(CategoryListCell.self, forCellReuseIdentifier: "CategoryListCell")
        return tableView
    }()
    
    let disposeBag: DisposeBag = DisposeBag()
    var viewModel: CategoryListViewModel!
    
    var listData: [CategoryListData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.dismissView()
    }
}

// MARK: - Func
extension CategoryListViewController {
    func bind() {
        let input = CategoryListViewModel.Input(viewDidLoadEvent: Observable.just(()),
                                                btnBackDidTabEvent: btn_NavigationBar.buttonRx.tap.asObservable())
        
        let output = viewModel.transform(form: input, disposeBag: disposeBag)
        
        output.categoryListData
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.listData = value
                view.tableView.reloadData()
            })
            .disposed(by: disposeBag)
            
    }
    
    func configure() {
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        self.view.backgroundColor = .white
        
        [statusView,
         btn_NavigationBar,
         tableView].forEach {
            self.view.addSubview($0)
        }
    }
    
    func configureConstraints() {
        statusView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(UIApplication.shared.statusBarHeight)
        }
        
        btn_NavigationBar.snp.makeConstraints { make in
            make.top.equalTo(statusView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(btn_NavigationBar.snp.bottom).offset(21)
            make.left.right.equalToSuperview().inset(26)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    
    func deleteAlert(id: String) {
        let alert = UIAlertController(title: "", message: I18NStrings.MyPage.categoryMsg, preferredStyle: .alert)
        let cancel = UIAlertAction(title: I18NStrings.cancel, style: .destructive)
        let confirm = UIAlertAction(title: I18NStrings.confirm, style: .default) { [weak self] action in
            self?.viewModel.isCategoryDelete.accept(id)
        }
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
}

// MARK: - TableView Delegate, DataSource
extension CategoryListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listData.count > 0 {
            tableView.restore()
            
            return listData.count
        } else {
            tableView.setEmptyView(page: "myPage")
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryListCell") as! CategoryListCell
        let data = listData[indexPath.row]
        
        cell.selectionStyle = .none
        
        cell.delegate = self
        
        cell.data = data
        
        cell.textField.text = data.categoryName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "") { [weak self] _, _, completion in
            let data = self?.listData[indexPath.row]
            self?.deleteAlert(id: data?.categoryId ?? "")
            completion(true)
        }
        
        delete.backgroundColor = .red
        delete.image = UIImage(imageSet: .trash)
        delete.title = nil
        
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

extension CategoryListViewController: CategoryListCellProtocol {
    func categoryNameEdit(name: String, id: String) {
        let data = CategoryListData(categoryId: id, categoryName: name)
        viewModel.isCategoryUpdate.accept(data)
    }
}
