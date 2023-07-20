//
//  MainViewController.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/26.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Toast_Swift

final class MainViewController: UIViewController {
    // MARK: - View Property
    private lazy var statusView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: "HomeCell")
        collectionView.register(SugRoutineCell.self, forCellWithReuseIdentifier: "SugRoutineCell")
        collectionView.register(MyPageCell.self, forCellWithReuseIdentifier: "MyPageCell")
        return collectionView
    }()
    
    private lazy var bottomTabView: BottomTabView = {
        let view = BottomTabView()
        return view
    }()
    
    let disposeBag: DisposeBag = DisposeBag()
    var viewModel: MainViewModel!
    
    var isDismiss: Bool?
    
    var findAllData: PublishRelay<FindAllRoutineDayModel> = PublishRelay()
    var findDayData: PublishRelay<FindRoutineDayModel> = PublishRelay()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getSettingNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let _ = isDismiss {
            viewModel.dismissView()
        }
    }
}

// MARK: - Func
extension MainViewController {
    func bind() {
        let input = MainViewModel.Input(viewDidLoadEvent: Observable.just(()),
                                        btnHomeDidTabEvent: bottomTabView.btn_HomeRx.tap.map { _ in MainAction.home},
                                        btnSugRoutineDidTabEvent: bottomTabView.btn_SugRoutineRx.tap.map { _ in MainAction.sugRouine},
                                        btnMyPageDidTabEvent: bottomTabView.btn_MyPageRx.tap.map { _ in MainAction.myPage })
        
        
        let output = viewModel.transform(form: input, disposeBag: disposeBag)
        
        output.bottomBtnTag
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                switch value {
                case .home:
                    view.bottomTabView.gap_Hidden = 1
                    view.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
                    view.viewModel.reloadState.accept(true)
                    break
                case .sugRouine:
                    view.bottomTabView.gap_Hidden = 2
                    view.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
                    break
                case .myPage:
                    view.bottomTabView.gap_Hidden = 3
                    view.collectionView.scrollToItem(at: IndexPath(item: 2, section: 0), at: .centeredHorizontally, animated: false)
                    break
                }
            })
            .disposed(by: disposeBag)
        
        output.findAllData
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.findAllData.accept(value)
            })
            .disposed(by: disposeBag)
        
        output.findDayData
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.findDayData.accept(value)
            })
            .disposed(by: disposeBag)
        
        output.viewDismiss
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.isDismiss = value
            })
            .disposed(by: disposeBag)
    }
    
    func configure() {
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        [statusView,
         collectionView,
         bottomTabView].forEach {
            view.addSubview($0)
        }
    }
    
    func configureConstraints() {
        statusView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(UIApplication.shared.statusBarHeight)
        }
        
        bottomTabView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(statusView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomTabView.snp.top)
        }
    }
    
    func openURL(url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
    
    func getUserDefault() -> String {
        let value = UserDefaults.standard.value(forKey: UserDefaultKey.isRutinPush) as? String ?? ""
        
        return value
    }
    
    func getSettingPushState() -> Bool {
        let value = UserDefaults.standard.value(forKey: UserDefaultKey.isSettingPushState) as? Bool ?? false
        
        return value
    }
}

// MARK: - CollectionView Delegate
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell!
        
        if indexPath.row == 0 {
            let homeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
            
            homeCell.delegate = self
            
            findAllData
                .withUnretained(self)
                .subscribe(onNext: { (view, value) in
                    homeCell.calendarEvent.accept(value)
                })
                .disposed(by: disposeBag)

            findDayData
                .withUnretained(self)
                .subscribe(onNext: { (view, value) in
                    homeCell.dayEvent.accept(value)
                })
                .disposed(by: disposeBag)
            
            cell = homeCell
        }
        
        else if indexPath.row == 1 {
            let sugRoutineCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SugRoutineCell", for: indexPath) as! SugRoutineCell
            
            cell = sugRoutineCell
        }
        
        else if indexPath.row == 2 {
            let myPageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPageCell", for: indexPath) as! MyPageCell
            
            myPageCell.delegate = self
            
            var state = false
            
            let value = UserDefaults.standard.value(forKey: UserDefaultKey.isSettingPushState) as? Bool ?? false
            
            if value {
                state = true
            }

            myPageCell.toggleState = state
            
            cell = myPageCell
        }
        
        return cell
    }
}

// MARK: - HomeCell Protocol
extension MainViewController: HomeCellPtorocol {
    func openRoutineView(title: String, selectDate: Date?) {
        if title == I18NStrings.Routine.add {
            if Date().toDayTime("yyyyMMdd") == selectDate?.toDayTime("yyyyMMdd") {
                viewModel.routineGet.accept(title)
            } else {
                self.showDefaultAlert(title: "", msg: I18NStrings.Routine.addMsg)
            }
        } else {
            viewModel.routineGet.accept(title)
        }
    }
    
    func routineDayAPI(data: String) {
        viewModel.routineDay.accept(data)
    }
    
    func routineDeleteAPI() {
        let alert = UIAlertController(title: nil, message: I18NStrings.Routine.deleteMsg, preferredStyle: .alert)
        let cancel = UIAlertAction(title: I18NStrings.cancel, style: .destructive)
        let confirm = UIAlertAction(title: I18NStrings.confirm, style: .default) { [weak self] action in
            self?.viewModel.routineDelete.accept(true)
        }
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
    func routineCheckAPI(data: FindRoutineList, date: Date?) {
        if Date().toDayTime("yyyyMMdd") == date?.toDayTime("yyyyMMdd") {
            viewModel.routineCheck.accept(data)
        } else {
            showDefaultAlert(title: "", msg: I18NStrings.Routine.checkMsg)
        }
    }
}

// MARK: - MyPageCell Protocol
extension MainViewController: MyPageCellProtocol {
    func categoryViewState(state: Bool) {
        viewModel.coordinator?.pushCategoryList()
    }
    
    func logOut() {
        let alert = UIAlertController(title: I18NStrings.MyPage.logout, message: I18NStrings.MyPage.logoutMsg, preferredStyle: .alert)
        let cancel = UIAlertAction(title: I18NStrings.cancel, style: .destructive)
        let confirm = UIAlertAction(title: I18NStrings.confirm, style: .default) { [weak self] action in
            self?.isDismiss = true
            self?.viewModel.logOut()
        }
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
    func withDraw() {
        let alert = UIAlertController(title: I18NStrings.MyPage.leave, message: I18NStrings.MyPage.leaveMsg, preferredStyle: .alert)
        let confirm = UIAlertAction(title: I18NStrings.MyPage.leave, style: .destructive) { [weak self] action in
            if UserInfo.appleLogin == "Y" {
                self?.appleAlert()
            } else {
                self?.viewModel.myPageWithDraw.accept(true)
            }
        }
        let cancel = UIAlertAction(title: I18NStrings.MyPage.leaveCancel, style: .default)
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func appleAlert() {
        let alert = UIAlertController(title: I18NStrings.MyPage.appleTitle, message: I18NStrings.MyPage.appleMsg, preferredStyle: .alert)
        let confirm = UIAlertAction(title: I18NStrings.confirm, style: .default) { [weak self] action in
            self?.viewModel.myPageAppleLogin.accept(true)
        }
        
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
    func openTerms(url: String) {
        openURL(url: url)
    }
    
    func openSetting() {
        let setting = URL(string: UIApplication.openSettingsURLString)!
        UserInfo.isSettingTriger = true
        UIApplication.shared.open(setting)
    }
    
    @objc func getSettingNotification(notification: NSNotification) {
            UNUserNotificationCenter.current().getNotificationSettings { [weak self] setting in
                if UserInfo.isSettingTriger {
                    switch setting.authorizationStatus {
                    case .authorized:
                        
                        if !UserInfo.systemPushState {
                            UserInfo.systemPushState = true
                            UserDefaults.standard.setValue(true, forKey: UserDefaultKey.isSettingPushState)
                            UserDefaults.standard.synchronize()
                            DispatchQueue.main.async {
                                self?.view.makeToast(I18NStrings.MyPage.pushOn)
                                self?.collectionView.reloadData()
                            }
                        }
                        break
                        
                    case .denied:
                        if UserInfo.systemPushState {
                            UserInfo.systemPushState = false
                            UserDefaults.standard.setValue(false, forKey: UserDefaultKey.isSettingPushState)
                            UserDefaults.standard.synchronize()
                            DispatchQueue.main.async {
                                self?.view.makeToast(I18NStrings.MyPage.pushOff)
                                self?.collectionView.reloadData()
                            }
                        }
                        break
                        
                    case .notDetermined:
                        break
                        
                    default:
                        break
                    }
                    
                    UserInfo.isSettingTriger = false
                }
            }
    }
}
