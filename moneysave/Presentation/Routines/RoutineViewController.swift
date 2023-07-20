//
//  RoutineViewController.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/28.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class RoutineViewController: UIViewController {
    private lazy var statusView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var btn_NavigationBar: NavigationBarView = {
        let button = NavigationBarView()
        return button
    }()
    
    private lazy var categoryDummyView: CategoryDummyView = {
        let view = CategoryDummyView()
        view.isHidden = true
        return view
    }()
    
    private lazy var dimView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var scrollContentsView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var routineNameView: RoutineNameView = {
        let view = RoutineNameView()
        return view
    }()
    
    private lazy var routineCategoryView: RoutineCategoryView = {
        let view = RoutineCategoryView()
        view.delegate = self
        return view
    }()
    
    private lazy var routineDayView: RoutineDayView = {
        let view = RoutineDayView()
        view.delegate = self
        return view
    }()
    
    private lazy var routineTimeView: RoutineTimeView = {
        let view = RoutineTimeView()
        view.delegate = self
        return view
    }()
    
    private lazy var routineAlarmView: RoutineAlarmView = {
        let view = RoutineAlarmView()
        return view
    }()
    
    private lazy var routineDatePickerView: RoutineDatePickerView = {
        let view = RoutineDatePickerView()
        view.isHidden = true
        return view
    }()
    
    private lazy var routineCategoryAddView: RoutineCategoryAddView = {
        let view = RoutineCategoryAddView()
        view.isHidden = true
        return view
    }()
    
    private lazy var btn_Routine: UIButton = {
        let button = UIButton()
        button.setTitle(I18NStrings.save, for: .normal)
        button.backgroundColor = .black
        button.contentEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        return button
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let disposeBag: DisposeBag = DisposeBag()
    var viewModel: RoutineViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateConfigure()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.dismissView()
    }
}

// MARK: - Func
extension RoutineViewController {
    func bind() {
        view.backgroundColor = .white
        
        self.setupToHideKeyboardOnTapOnView()
        
        btn_NavigationBar.title = viewModel.title
        
        if viewModel.title == I18NStrings.Routine.add {
            btn_Routine.backgroundColor = UIColor(colorSet: .Gray_153)
            bottomView.backgroundColor = UIColor(colorSet: .Gray_153)
        } else {
            btn_Routine.setTitle(I18NStrings.edit, for: .normal)
        }
        
        if let data = viewModel.data {
            routineNameView.nameField.text = data.data.routineName
            routineCategoryView.isSelect = data.data.categoryName
            routineDayView.selectArray = data.data.weekTypes
            routineDayView.btnDayEvent(sender: nil)
            routineTimeView.selectTag = data.data.routineTimeZone.toTimeZone()
            
            if data.data.alarmStatus == "ON" {
                routineAlarmView.opstionViewState = false
                routineAlarmView.switch.isOn = true
                routineAlarmView.alarmDateText = data.data.alarmTime.toDateFormat(format: "HHmm", changeFormat: "a HH:mm")
            }
            
            viewModel.isRoutineName = data.data.routineName
            viewModel.isRoutineCategory = data.data.categoryId
            viewModel.isRoutineTime = data.data.routineTimeZone
            viewModel.isRoutineDay = data.data.weekTypes
            viewModel.isRoutineAlarmOn = data.data.alarmStatus
            viewModel.isRoutineAlarm = data.data.alarmTime
        }
        
        let input = RoutineViewModel.Input(viewDidLoadEvent: Observable.just(()),
                                           backDidTapEvent: btn_NavigationBar.buttonRx.tap.asObservable(),
                                           routineNameFieldTextEvent: routineNameView.fieldRx.text,
                                           alarmToggleEvent: routineAlarmView.toggleRx.value,
                                           alarmTimeDidTapEvent: routineAlarmView.timeRx.tap.asObservable(),
                                           alarmDateConfirmDidTapEvent: routineDatePickerView.confirmRx.tap.map { _ in self.routineDatePickerView.dateSelectValue },
                                           categoryAddTextFieldEvent: routineCategoryAddView.fieldRx.text,
                                           categoryAddSaveDidTapEvent: routineCategoryAddView.saveRx.tap.asObservable(),
                                           categoryAddCancelDidTapEvent: routineCategoryAddView.cancelRx.tap.asObservable(),
                                           routineDidTapEvent: btn_Routine.rx.tap.asObservable())
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)

        output.alarmView
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.routineAlarmView.opstionViewState = !value
            })
            .disposed(by: disposeBag)
        
        output.alarmDatePickerView
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.routineDatePickerView.viewState = !value
            })
            .disposed(by: disposeBag)
        
        output.alarmDateString
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "ko_KR")
                dateFormatter.timeZone = TimeZone(abbreviation: "KST")
                dateFormatter.dateFormat = "a HH:mm"
                view.routineAlarmView.alarmDateText = dateFormatter.string(from: value!)
            })
            .disposed(by: disposeBag)
        
        output.categoryListArray
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.routineCategoryView.tagArray = value
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    view.routineCategoryView.updateConfigre(height: view.categoryDummyView.frame.size.height)
                }
            })
            .disposed(by: disposeBag)
        
        output.categoryAddView
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.routineCategoryAddView.isHidden = !value
                view.routineCategoryAddView.fieldConponent.text = ""
            })
            .disposed(by: disposeBag)
        
        output.validationState
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                let backColor = value ? .black : UIColor(colorSet: .Gray_153)!
                view.btn_Routine.backgroundColor = backColor
                view.bottomView.backgroundColor = backColor
            })
            .disposed(by: disposeBag)
        
        output.msgAlert
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.showDefaultAlert(title: "", msg: value)
            })
            .disposed(by: disposeBag)
        
        output.routineNameFieldValidation
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.routineNameView.nameField.text = value
            })
            .disposed(by: disposeBag)
        
        output.routineCategoryFieldValidation
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.routineCategoryAddView.fieldConponent.text = value
            })
            .disposed(by: disposeBag)
    }
    
    func configure() {
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        [statusView,
         btn_NavigationBar,
         categoryDummyView,
         scrollView,
         bottomView,
         btn_Routine,
         routineDatePickerView,
         routineCategoryAddView,
         dimView].forEach {
            view.addSubview($0)
        }
        
        scrollView.addSubview(scrollContentsView)
        
        [routineNameView,
         routineCategoryView,
         routineDayView,
         routineTimeView,
         routineAlarmView].forEach {
            scrollContentsView.addSubview($0)
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
        
        categoryDummyView.snp.makeConstraints { make in
            make.top.equalTo(btn_NavigationBar.snp.bottom)
            make.left.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(btn_NavigationBar.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(btn_Routine.snp.top)
        }
        
        bottomView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(UIApplication.shared.bottomHeight)
        }
        
        btn_Routine.snp.makeConstraints { make in
            make.bottom.equalTo(bottomView.snp.top)
            make.left.right.equalToSuperview()
        }
        
        scrollContentsView.snp.makeConstraints { make in
            make.centerX.top.bottom.width.equalToSuperview()
        }
        
        routineNameView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.left.right.equalToSuperview()
        }
        
        routineCategoryView.snp.makeConstraints { make in
            make.top.equalTo(routineNameView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }
        
        routineDayView.snp.makeConstraints { make in
            make.top.equalTo(routineCategoryView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }
        
        routineTimeView.snp.makeConstraints { make in
            make.top.equalTo(routineDayView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }
        
        routineAlarmView.snp.makeConstraints { make in
            make.top.equalTo(routineTimeView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        
        routineDatePickerView.snp.makeConstraints { make in
            make.top.equalTo(statusView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        routineCategoryAddView.snp.makeConstraints { make in
            make.top.equalTo(statusView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        dimView.snp.makeConstraints { make in
            make.top.equalTo(btn_NavigationBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func updateConfigure() {
        DispatchQueue.main.async { [weak self] in
            self?.routineTimeView.updateConfigre(height: (self?.routineTimeView.contentsHeight)!)
            
            let btn = (self?.routineDayView.btnArray)!
            
            for i in btn {
                i.layer.cornerRadius = i.bounds.height / 2
            }
            
            self?.dimView.isHidden = true
        }
    }
}

// MARK: - Protocol
extension RoutineViewController: RoutineCategoryViewProtocol, RoutineDayViewProtocol,RoutineTimeViewProtocol {
    func categoryAddViewState(state: Bool) {
        routineCategoryAddView.isHidden = false
    }
    
    func selectCategoryValue(value: String) {
        viewModel.isRoutineCategory = value
        viewModel.checkValidation()
    }
    
    func selectDayValue(value: [String]) {
        viewModel.isRoutineDay = value
    }
    
    func selectTimeValue(value: String) {
        viewModel.isRoutineTime = value
        viewModel.checkValidation()
    }
}
