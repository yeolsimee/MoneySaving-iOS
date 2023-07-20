//
//  MainViewModel.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/26.
//

import RxSwift
import RxCocoa

final class MainViewModel {
    var coordinator: MainCoordinator?
    
    private let mainUseCase: MainUseCase
    
    var routineAllDay: BehaviorRelay<String> = BehaviorRelay(value: Date().toDayTime("yyyyMM"))
    var routineDay: BehaviorRelay<String> = BehaviorRelay(value: Date().toDayTime("yyyyMMdd"))
    var routineDelete: PublishRelay<Bool> = PublishRelay()
    var routineGet: PublishRelay<String> = PublishRelay()
    var routineCheck: PublishRelay<FindRoutineList> = PublishRelay()
    
    var myPageWithDraw: PublishRelay<Bool> = PublishRelay()
    var myPageAppleLogin: PublishRelay<Bool> = PublishRelay()
    
    var reloadState: PublishRelay<Bool> = PublishRelay()
    
    var isAllRoutineDay: String?
    var isRoutineDay: String?
    
    init(coordinator: MainCoordinator, mainUseCase: MainUseCase) {
        self.coordinator = coordinator
        self.mainUseCase = mainUseCase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let btnHomeDidTabEvent: Observable<MainAction>
        let btnSugRoutineDidTabEvent: Observable<MainAction>
        let btnMyPageDidTabEvent: Observable<MainAction>
    }
    
    struct Output {
        var bottomBtnTag: PublishRelay<MainAction> = PublishRelay()
        var findAllData: PublishRelay<FindAllRoutineDayModel> = PublishRelay()
        var findDayData: PublishRelay<FindRoutineDayModel> = PublishRelay()
        var viewDismiss: PublishRelay<Bool> = PublishRelay()
    }
    
    func transform(form input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        Observable.merge(
            input.btnHomeDidTabEvent,
            input.btnSugRoutineDidTabEvent,
            input.btnMyPageDidTabEvent
        )
        .withUnretained(self)
        .subscribe(onNext: { (view, value) in
            output.bottomBtnTag.accept(value)
        })
        .disposed(by: disposeBag)
        
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                view.routineAlarmListAPI(disposeBag: disposeBag)
            })
            .disposed(by: disposeBag)
        
        routineDay
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.isRoutineDay = value
                view.findRoutineDayAPI(date: value, checkRoutine: "", output: output, disposeBag: disposeBag)
            })
            .disposed(by: disposeBag)
        
        routineAllDay
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.isAllRoutineDay = value
                view.findAllRoutineDayAPI(day: value, output: output, disposeBag: disposeBag)
            })
            .disposed(by: disposeBag)
        
        myPageWithDraw
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.withDrawAPI(output: output, disposeBag: disposeBag)
            })
            .disposed(by: disposeBag)
        
        reloadState
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                if value {
                    view.findAllRoutineDayAPI(day: view.isAllRoutineDay ?? "", output: output, disposeBag: disposeBag)
                    view.findRoutineDayAPI(date: view.isRoutineDay ?? "", checkRoutine: "", output: output, disposeBag: disposeBag)
                    view.routineAlarmListAPI(disposeBag: disposeBag)
                }
            })
            .disposed(by: disposeBag)
        
        routineDelete
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.routineDeleteAPI(output: output, disposeBag: disposeBag)
            })
            .disposed(by: disposeBag)
        
        routineGet
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                if value == I18NStrings.Routine.add {
                    view.coordinator?.pushRoutine(title: value, data: nil)
                } else {
                    view.routineGetAPI(title: value, disposeBag: disposeBag)
                }
                
            })
            .disposed(by: disposeBag)
        
        routineCheck
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                let chekcYN = value.routineCheckYN == "N" ? "Y" : "N"
                let dto = RoutineCheckDTO(routineCheckYN: chekcYN,
                                          routineId: value.routineId,
                                          routineDay: view.isRoutineDay ?? "")
                
                view.routineCheckAPI(dto: dto, output: output, disposeBag: disposeBag)
            })
            .disposed(by: disposeBag)
        
        myPageAppleLogin
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                view.mainUseCase.appleLoginStart()
            })
            .disposed(by: disposeBag)
        
        mainUseCase.appleInfo
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.withDrawAPI(output: output, disposeBag: disposeBag)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func findRoutineDayAPI(date: String, checkRoutine: String, output: Output, disposeBag: DisposeBag) {
        let dto = FindRoutineDayDTO(date: date, checkedRoutineShow: checkRoutine)
        
        mainUseCase.findRoutineDayRequest(dto)
            .withUnretained(self)
            .subscribe(onNext: { (view, model) in
                output.findDayData.accept(model)
            })
            .disposed(by: disposeBag)
    }
    
    func findAllRoutineDayAPI(day: String?, output: Output, disposeBag: DisposeBag) {
        let dto = FindAllRoutineDayDTO(startDate: day! + "01", endDate: day! + "31")
        
        mainUseCase.findAllRoutineDayRequest(dto)
            .withUnretained(self)
            .subscribe(onNext: { (view, model) in
                output.findAllData.accept(model)
            })
            .disposed(by: disposeBag)
    }
    
    func routineDeleteAPI(output: Output, disposeBag: DisposeBag) {
        mainUseCase.routineDeleteRequest()
            .withUnretained(self)
            .subscribe(onNext: { (view, model) in
                if model.success {
                    UserInfo.routineId = ""
                    view.findAllRoutineDayAPI(day: view.isAllRoutineDay ?? "", output: output, disposeBag: disposeBag)
                    view.findRoutineDayAPI(date: view.isRoutineDay ?? "", checkRoutine: "", output: output, disposeBag: disposeBag)
                    view.routineAlarmListAPI(disposeBag: disposeBag)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func routineGetAPI(title: String, disposeBag: DisposeBag) {
        mainUseCase.routineGetRequest()
            .withUnretained(self)
            .subscribe(onNext: { (view, model) in
                if model.success {
                    view.coordinator?.pushRoutine(title: title, data: model)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func routineCheckAPI(dto: RoutineCheckDTO, output: Output, disposeBag: DisposeBag) {
        mainUseCase.routineCheckRequest(dto)
            .withUnretained(self)
            .subscribe(onNext: { (view, model) in
                if model.success {
                    view.findAllRoutineDayAPI(day: view.isAllRoutineDay ?? "", output: output, disposeBag: disposeBag)
                    view.findRoutineDayAPI(date: view.isRoutineDay ?? "", checkRoutine: "", output: output, disposeBag: disposeBag)
                    view.routineAlarmListAPI(disposeBag: disposeBag)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func routineAlarmListAPI(disposeBag: DisposeBag) {
        mainUseCase.routineAlarmListRequest()
            .withUnretained(self)
            .subscribe(onNext: { (view, model) in
                if model.success {
                    if model.data.count > 0 {
                        var pushData: [PushModel] = []
                        let systemPush = PushModel(id: "systemPush", day: ["SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"], hour: "23", min: "00", second: "00", title: "", msg: I18NStrings.Routine.systemPushMsg)
                        
                        pushData.append(systemPush)
                        
                        for i in model.data {
                            if i.alarmStatus == "ON" {
                                let hour = i.alarmTime.toDateFormat(format: "HHmm", changeFormat: "HH")
                                let min = i.alarmTime.toDateFormat(format: "HHmm", changeFormat: "mm")
                                pushData.append(PushModel(id: "\(i.routineId)", day: i.weekTypes, hour: hour, min: min, second: "00", title: i.categoryName, msg: i.routineName))
                            }
                        }
                        
                        view.pushSet(data: pushData)
                    }
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    func logOut() {
        UserInfo.token = ""
        UserInfo.userToken = ""
        UserInfo.userName = ""
        UserInfo.routineId = ""
        UserInfo.appleLogin = "N"
        
        UserDefaults.standard.setValue("N", forKey: UserDefaultKey.isAutoLogin)
        UserDefaults.standard.synchronize()
        
        coordinator?.popView()
    }
    
    func dismissView() {
        coordinator?.dismissView()
    }
    
    func withDrawAPI(output: Output, disposeBag: DisposeBag) {
        mainUseCase.withdrawRequest()
            .withUnretained(self)
            .subscribe(onNext: { (view, model) in
                if model.success {
                    output.viewDismiss.accept(true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        view.logOut()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func pushSet(data: [PushModel]) {
        print("2435 data : \(data)")
        var data = data
        // 로컬 푸시 리스트에서 새롭게 추가될 푸시랑 같은 시간대(시,분)이 존재하면 초 단위를 +1을 해줌(푸시 안겹치게 위해서)
        UNUserNotificationCenter.current().getPendingNotificationRequests { list in
            if list.count > 0 {
                for i in list {
                    if let trigger = i.trigger as? UNCalendarNotificationTrigger {
                        if let hour = trigger.dateComponents.hour, let min = trigger.dateComponents.minute {
                            
                            if data.count > 0 {
                                for j in 0 ..< data.count {
                                    var result = data[j]
                                    
                                    if hour == Int(result.hour) && min == Int(result.min) {
                                        if let second = trigger.dateComponents.second {
                                            
                                            if second + 1 < 10 {
                                                data[j].second = "0" + String(second + 1)
                                            } else {
                                                data[j].second = String(second + 1)
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
        // 로컬 푸시 리스트를 모두 초기화 한 후 새로운 알림을 추가하여 다시 로컬 푸시 리시트 작성
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let userNotification = UNUserNotificationCenter.current()
            userNotification.removeAllDeliveredNotifications()
            userNotification.removeAllPendingNotificationRequests()
            
            var trigger: UNCalendarNotificationTrigger!
            var request: UNNotificationRequest!
            
            for i in data {
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: i.title, arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: i.msg, arguments: nil)
                
                var dateComponents = DateComponents()
                dateComponents.timeZone = TimeZone(abbreviation: "KST")
                dateComponents.calendar = Calendar.current
                
                
                if i.day.count > 0 {
                    
                    for j in 0..<i.day.count {
                        print("i.day[j] : \(i.day[j]) | title : \(i.title)")
                        
                        dateComponents.weekday = i.day[j].toWeekInt()
                        dateComponents.hour = Int(i.hour)
                        dateComponents.minute = Int(i.min)
                        dateComponents.second = Int(i.second)
                        
                        trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                        
                        var id = i.id
                        
                        if i.day.count > 1 {
                            id = id.appending(String(j + 1))
                        }
                        
                        request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                        userNotification.add(request)
                        
                        if j == i.day.count {
                            return
                        }
                    }
                    
                } else {
                    dateComponents.hour = Int(i.hour)
                    dateComponents.minute = Int(i.min)
                    trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    print("trigger2 : \(trigger)")
                    request = UNNotificationRequest(identifier: i.id, content: content, trigger: trigger)
                    userNotification.add(request)
                }
            }
        }
        
    }
}
