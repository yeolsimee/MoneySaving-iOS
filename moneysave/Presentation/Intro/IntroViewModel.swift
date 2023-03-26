//
//  IntroViewModel.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/15.
//

import RxSwift
import RxCocoa
import FirebaseFunctions
import Firebase

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
    var presentingView: UIViewController?
    
    private let introUseCase: IntroUseCase
    private lazy var functions = Functions.functions(region: "asia-northeast1")
    
    //    let pushList = PushTest(id: "테스트1", day: ["월", "화", "수", "목", "금", "토", "일"], hour: "13", min: "00", title: "일주일 테스트2", msg: "일주일 13:00시 테스트2")
    //    let pushList = PushTest(id: "테스트2", day: ["월", "수", "금", "일"], hour: "14", min: "00", title: "월수금일 테스트", msg: "14:00시 테스트")
    //    let pushList = PushTest(id: "테스트3", day: [], hour: "15", min: "00", title: "하루만 테스트", msg: "요일 체크 안할 경우 하루 테스트")
    let pushList = PushTest(id: "테스트4", day: ["토"], hour: "14", min: "00", second: "00", title: "토 반복 테스트", msg: "토 반복14:00시 테스트")
    
    init(coordinator: IntroCoordinator,
         introUseCase: IntroUseCase,
         presentingView: UIViewController) {
        self.coordinator = coordinator
        self.introUseCase = introUseCase
        self.presentingView = presentingView
    }
    
    struct Input {
        let btnEvent: Observable<Void>
    }
    
    struct Output {
        
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.btnEvent
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                view.pushSet(data: view.pushList)
            })
            .disposed(by: disposeBag)
        
        introUseCase.appleInfo
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                print("2929 value : \(value)")
            })
            .disposed(by: disposeBag)
        //        introUseCase.naverInfo
        //            .observe(on: MainScheduler.asyncInstance)
        //            .withUnretained(self)
        //            .subscribe(onNext: { (view, value) in
        //                view.test(data: value)
        //            })
        //            .disposed(by: disposeBag)
        
        //        introUseCase.kakaoInfo
        //            .observe(on: MainScheduler.asyncInstance)
        //            .withUnretained(self)
        //            .subscribe(onNext: { (view, value) in
        //                view.test(data: value)
        //            })
        //            .disposed(by: disposeBag)
        
        //        introUseCase.googleInfo
        //            .observe(on: MainScheduler.asyncInstance)
        //            .withUnretained(self)
        //            .subscribe(onNext: { (view, state) in
        //
        //            })
        //            .disposed(by: disposeBag)
        
        return output
    }
    
    func test() {
        // kakao
        //        functions.httpsCallable("kakaoCustomAuth").call(data.token.accessToken) { result, error in
        //
        //            if let error = error {
        //                print("2818 \(error)")
        //
        //            }
        //
        //            if let res = result {
        //                let resdic = res.data as? [String:Any]
        //                let tt = resdic?["firebase_token"] as? String ?? "고장남"
        //                print("2818 \(tt)")
        //            }
        //        }
        
        // naver
        //        functions.httpsCallable("naverCustomAuth").call(data.accessToken ?? "") { result, error in
        //            if let error = error {
        //                print("2818 \(error)")
        //            }
        //
        //            if let res = result {
        //                let resdic = res.data as? [String:Any]
        //                let tt = resdic?["firebase_token"] as? String ?? "고장남"
        //                print("2818 \(tt)")
        //            }
        //        }
        
        let email = "kmui123@naver.com"
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://moneysaving.page.link/Tbeh?email=\(email)")
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        actionCodeSettings.handleCodeInApp = true
        
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
            if let error = error {
                print("error : \(error.localizedDescription)")
                return
            }
            
            print("GOGO")
        }
    }
    
    func pushSet(data: PushTest) {
        var data = data

        // 로컬 푸시 리스트에서 새롭게 추가될 푸시랑 같은 시간대(시,분)이 존재하면 초 단위를 +1을 해줌(푸시 안겹치게 위해서)
        UNUserNotificationCenter.current().getPendingNotificationRequests { list in
            if list.count > 0 {
                for i in list {
                    if let trigger = i.trigger as? UNCalendarNotificationTrigger {
                        if let hour = trigger.dateComponents.hour, let min = trigger.dateComponents.minute {
                            if hour == Int(data.hour) && min == Int(data.min) {
                                if let second = trigger.dateComponents.second {

                                    if second + 1 < 10 {
                                        data.second = "0" + String(second + 1)
                                    } else {
                                        data.second = String(second + 1)
                                    }

                                }
                            }
                        }
                    }
                }
            }
        }

        // 로컬 푸시 리스트를 모두 초기화 한 후 새로운 알림을 추가하여 다시 로컬 푸시 리시트 작성
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

            let userNotification = UNUserNotificationCenter.current()
            userNotification.removeAllDeliveredNotifications()
            userNotification.removeAllPendingNotificationRequests()

            var trigger: UNCalendarNotificationTrigger!
            var request: UNNotificationRequest!

            var list: [PushTest]!

            if let saveData = UserDefaults.standard.object(forKey: UserDefaultKey.isRutinPush) as? Data {
                let decoder = JSONDecoder()

                if let save = try? decoder.decode([PushTest].self, from: saveData) {
                    list = save
                    list.append(data)
                } else {
                    list = [data]
                }

            } else {
                list = [data]
            }

            // Struct -> Data로 변환 시켜서 저장
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(list) {
                UserDefaults.standard.set(encoded, forKey: UserDefaultKey.isRutinPush)
                UserDefaults.standard.synchronize()
            }

            for i in list! {
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: i.title, arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: i.msg, arguments: nil)

                var dateComponents = DateComponents()
                dateComponents.calendar = Calendar.current


                if i.day.count > 0 {

                    for j in 0..<i.day.count {
                        dateComponents.weekday = i.day[j].toWeekInt()
                        dateComponents.hour = Int(i.hour)
                        dateComponents.minute = Int(i.min)
                        dateComponents.second = Int(i.second)

                        trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                        request = UNNotificationRequest(identifier: i.id, content: content, trigger: trigger)
                        userNotification.add(request)
                    }

                } else {
                    dateComponents.hour = Int(i.hour)
                    dateComponents.minute = Int(i.min)
                    trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    request = UNNotificationRequest(identifier: i.id, content: content, trigger: trigger)
                    userNotification.add(request)
                }
            }
        }
    }
}
