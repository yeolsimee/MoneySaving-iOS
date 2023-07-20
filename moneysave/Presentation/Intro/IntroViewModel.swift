//
//  IntroViewModel.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/15.
//

import RxSwift
import RxCocoa
import Firebase
import FirebaseFunctions

struct PushTest: Codable {
    var id: String
    var day: [String]
    var hour: String
    var min: String
    var second: String
    var title: String
    var msg: String
}

final class IntroViewModel {
    var coordinator: IntroCoordinator?
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let introUseCase: IntroUseCase
    
    init(coordinator: IntroCoordinator,
         introUseCase: IntroUseCase) {
        
        self.coordinator = coordinator
        self.introUseCase = introUseCase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .delaySubscription(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { (view, _) in
                view.systemPushStateCheck()
                view.coordinator?.pushToLogin()
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
//    func pushSet(data: PushTest) {
//        var data = data
//
//        // 로컬 푸시 리스트에서 새롭게 추가될 푸시랑 같은 시간대(시,분)이 존재하면 초 단위를 +1을 해줌(푸시 안겹치게 위해서)
//        UNUserNotificationCenter.current().getPendingNotificationRequests { list in
//            if list.count > 0 {
//                for i in list {
//                    if let trigger = i.trigger as? UNCalendarNotificationTrigger {
//                        if let hour = trigger.dateComponents.hour, let min = trigger.dateComponents.minute {
//                            if hour == Int(data.hour) && min == Int(data.min) {
//                                if let second = trigger.dateComponents.second {
//
//                                    if second + 1 < 10 {
//                                        data.second = "0" + String(second + 1)
//                                    } else {
//                                        data.second = String(second + 1)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//
//
//        // 로컬 푸시 리스트를 모두 초기화 한 후 새로운 알림을 추가하여 다시 로컬 푸시 리시트 작성
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//
//            let userNotification = UNUserNotificationCenter.current()
//            userNotification.removeAllDeliveredNotifications()
//            userNotification.removeAllPendingNotificationRequests()
//
//            var trigger: UNCalendarNotificationTrigger!
//            var request: UNNotificationRequest!
//
//            var list: [PushTest]!
//
//            if let saveData = UserDefaults.standard.object(forKey: UserDefaultKey.isRutinPush) as? Data {
//                let decoder = JSONDecoder()
//
//                if let save = try? decoder.decode([PushTest].self, from: saveData) {
//                    list = save
//                    list.append(data)
//                } else {
//                    list = [data]
//                }
//
//            } else {
//                list = [data]
//            }
//
//            // Struct -> Data로 변환 시켜서 저장
//            let encoder = JSONEncoder()
//            if let encoded = try? encoder.encode(list) {
//                UserDefaults.standard.set(encoded, forKey: UserDefaultKey.isRutinPush)
//                UserDefaults.standard.synchronize()
//            }
//
//            for i in list! {
//                let content = UNMutableNotificationContent()
//                content.title = NSString.localizedUserNotificationString(forKey: i.title, arguments: nil)
//                content.body = NSString.localizedUserNotificationString(forKey: i.msg, arguments: nil)
//
//                var dateComponents = DateComponents()
//                dateComponents.timeZone = TimeZone(abbreviation: "KST")
//                dateComponents.calendar = Calendar.current
//
//
//                if i.day.count > 0 {
//
//                    for j in 0..<i.day.count {
//                        print("i.day[j] : \(i.day[j]) | title : \(i.title)")
//
//                        dateComponents.weekday = i.day[j].toWeekInt()
//                        dateComponents.hour = Int(i.hour)
//                        dateComponents.minute = Int(i.min)
//                        dateComponents.second = Int(i.second)
//
//                        trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//
//                        var id = i.id
//
//                        if i.day.count > 1 {
//                            id = id.appending(String(j + 1))
//                        }
//
//                        request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
//                        userNotification.add(request)
//
//                        if j == i.day.count {
//                            return
//                        }
//                    }
//
//                } else {
//                    dateComponents.hour = Int(i.hour)
//                    dateComponents.minute = Int(i.min)
//                    trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//                    print("trigger2 : \(trigger)")
//                    request = UNNotificationRequest(identifier: i.id, content: content, trigger: trigger)
//                    userNotification.add(request)
//                }
//            }
//        }
//    }
    
    func systemPushStateCheck() {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings { [weak self] permission in
            if permission.authorizationStatus == .authorized {
                UserInfo.systemPushState = true
                
                if !(self?.getFirstState())! {
                    UserDefaults.standard.setValue(true, forKey: UserDefaultKey.isSettingPushState)
                    UserDefaults.standard.setValue(true, forKey: UserDefaultKey.isFirstApp)
                    UserDefaults.standard.synchronize()
                }
                
            } else {
                UserInfo.systemPushState = false
                UserDefaults.standard.setValue(false, forKey: UserDefaultKey.isSettingPushState)
                UserDefaults.standard.synchronize()
            }
        }
        
        print("UserInfo : \(UserInfo.systemPushState)")
    }
    
    func getFirstState() -> Bool {
        let value = UserDefaults.standard.value(forKey: UserDefaultKey.isFirstApp) as? Bool ?? false
        
        return value
    }
    
}
