//
//  RoutineViewModel.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/28.
//

import RxSwift
import RxCocoa

final class RoutineViewModel {
    var coordinator: RoutineCoordinator?
    
    private let routineUseCase: RoutineUseCase
    
    var title = ""
    var data: RoutineGetModel?
    
    var categoryList: [String] = []
    var categoryName: String?
    
    var isValidationState: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var isRoutineName: String?
    var isRoutineCategory: String?
    var isRoutineTime: String?
    var isRoutineDay: [String] = []
    var isRoutineAlarmOn: String = "OFF"
    var isRoutineAlarm: String?
    
    init(coordinator: RoutineCoordinator, routineUseCase: RoutineUseCase) {
        self.coordinator = coordinator
        self.routineUseCase = routineUseCase
    }
    
    struct Input {
        var viewDidLoadEvent: Observable<Void>
        var backDidTapEvent: Observable<Void>
        var routineNameFieldTextEvent: ControlProperty<String?>
        var alarmToggleEvent: ControlProperty<Bool>
        var alarmTimeDidTapEvent: Observable<Void>
        var alarmDateConfirmDidTapEvent: Observable<Date?>
        var categoryAddTextFieldEvent: ControlProperty<String?>
        var categoryAddSaveDidTapEvent: Observable<Void>
        var categoryAddCancelDidTapEvent: Observable<Void>
        var routineDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var bindCollection: PublishRelay<[String]> = PublishRelay()
        var alarmView: PublishRelay<Bool> = PublishRelay()
        var alarmDatePickerView: PublishRelay<Bool> = PublishRelay()
        var alarmDateString: PublishRelay<Date?> = PublishRelay()
        var categoryAddView: PublishRelay<Bool> = PublishRelay()
        var categoryListArray: PublishRelay<[CategoryListData]> = PublishRelay()
        var validationState: PublishRelay<Bool> = PublishRelay()
        var msgAlert: PublishRelay<String> = PublishRelay()
        var routineNameFieldValidation: PublishRelay<String> = PublishRelay()
        var routineCategoryFieldValidation: PublishRelay<String> = PublishRelay()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                view.categoryListAPI(output: output, disposeBag: disposeBag)
            })
            .disposed(by: disposeBag)
        
        input.backDidTapEvent
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                view.coordinator?.popView()
            })
            .disposed(by: disposeBag)
        
        input.routineNameFieldTextEvent
            .orEmpty
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                if value.textMaxCount(count: 50) {
                    view.isRoutineName = value
                } else {
                    output.routineNameFieldValidation.accept(view.isRoutineName ?? "")
                }
                view.checkValidation()
            })
            .disposed(by: disposeBag)
        
        input.alarmToggleEvent
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                output.alarmView.accept(value)
                let state = value ? "ON" : "OFF"
                view.isRoutineAlarmOn = state
            })
            .disposed(by: disposeBag)
        
        input.alarmTimeDidTapEvent
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                output.alarmDatePickerView.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.alarmDateConfirmDidTapEvent
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "ko_KR")
                dateFormatter.timeZone = TimeZone(abbreviation: "KST")
                dateFormatter.dateFormat = "HHmm"
                let date = dateFormatter.string(from: value!)
                view.isRoutineAlarm = date
                output.alarmDatePickerView.accept(false)
                output.alarmDateString.accept(value)
            })
            .disposed(by: disposeBag)
        
        input.categoryAddTextFieldEvent
            .orEmpty
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                if value.textMaxCount(count: 14) {
                    view.categoryName = value
                } else {
                    output.routineCategoryFieldValidation.accept(view.categoryName ?? "")
                }
            })
            .disposed(by: disposeBag)
        
        input.categoryAddSaveDidTapEvent
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                if let text = view.categoryName {
                    let dto = CategoryInsertDTO(categoryName: text)
                    view.categoryInsertAPI(dto: dto, output: output, disposeBag: disposeBag)
                } else {
                    print("입력 안되어있음")
                }
            })
            .disposed(by: disposeBag)
        
        input.categoryAddCancelDidTapEvent
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                view.categoryName = nil
                output.categoryAddView.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.routineDidTapEvent
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                if view.title == I18NStrings.Routine.add {
                    // 저장하기
                    if view.isValidationState.value {
                        
                        if view.isRoutineAlarmOn == "ON" && view.isRoutineAlarm == nil {
                            output.msgAlert.accept("시간을 설정해주세요")
                            return
                        }
                        
                        let dto = RoutineCreateDTO(alarmStatus: view.isRoutineAlarmOn,
                                                   routineType: "PRIVATE",
                                                   alarmTime: view.isRoutineAlarm ?? "",
                                                   routineName: view.isRoutineName ?? "",
                                                   categoryId: view.isRoutineCategory ?? "",
                                                   weekTypes: view.isRoutineDay,
                                                   routineTimeZone: view.isRoutineTime ?? "")
                        print("dto : \(dto)")
                        view.routineCreateAPI(dto: dto, output: output, disposeBag: disposeBag)
                    }
                } else {
                    let dto = RoutineUpdateDTO(alarmStatus: view.isRoutineAlarmOn,
                                               routineType: "PRIVATE",
                                               alarmTime: view.isRoutineAlarm ?? "",
                                               routineName: view.isRoutineName ?? "",
                                               categoryId: view.isRoutineCategory ?? "",
                                               weekTypes: view.isRoutineDay,
                                               routineTimeZone: view.isRoutineTime ?? "")
                    print("dto : \(dto)")
                    view.routineUpdateAPI(dto: dto, output: output, disposeBag: disposeBag)
                }
            })
            .disposed(by: disposeBag)
        
        
        isValidationState
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                output.validationState.accept(value)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func dismissView() {
        coordinator?.dismissView()
    }
    
    func categoryListAPI(output: Output, disposeBag: DisposeBag) {
        routineUseCase.categoryListRequest()
            .withUnretained(self)
            .subscribe(onNext: { (view, model) in
                var listArray: [CategoryListData] = []
                if model.data.count > 0 {
                    for i in model.data {
                        listArray.append(i)
                    }
                    
                    if model.data.count < 10 {
                        listArray.append(CategoryListData(categoryId: nil, categoryName: "+"))
                    }
                    
                } else {
                    listArray.append(CategoryListData(categoryId: nil, categoryName: "+"))
                }
                
                output.categoryListArray.accept(listArray)
            }, onError: { error in
                var listArray: [CategoryListData] = []
                listArray.append(CategoryListData(categoryId: nil, categoryName: "+"))
                output.categoryListArray.accept(listArray)
            })
            .disposed(by: disposeBag)
    }
    
    func categoryInsertAPI(dto: CategoryInsertDTO, output: Output, disposeBag: DisposeBag) {
        routineUseCase.categoryInsertRequest(dto)
            .withUnretained(self)
            .subscribe(onNext: { (view, model) in
                if model.success {
                    output.categoryAddView.accept(false)
                    view.categoryListAPI(output: output, disposeBag: disposeBag)
                }
            }, onError: { error in
                print("error : \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func routineCreateAPI(dto: RoutineCreateDTO, output: Output, disposeBag: DisposeBag) {
        routineUseCase.routineCreateRequest(dto)
            .withUnretained(self)
            .subscribe(onNext: { (view, model) in
                print("model : \(model)")
                view.coordinator?.popView()
            }, onError: { error in
                print("error : \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func routineUpdateAPI(dto: RoutineUpdateDTO, output: Output, disposeBag: DisposeBag) {
        routineUseCase.routineUpdateRequest(dto)
            .withUnretained(self)
            .subscribe(onNext: { (view, model) in
                view.coordinator?.popView()
            }, onError: { error in
                print("error : \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func checkValidation() {
        guard let name = isRoutineName, name != "",
              let category = isRoutineCategory, category != "",
              let time = isRoutineTime, time != "" else {
            isValidationState.accept(false)
            return
        }
        
        isValidationState.accept(true)
    }
    
    
}
