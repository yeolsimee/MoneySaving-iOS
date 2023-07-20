//
//  MainUseCase.swift
//  moneysave
//
//  Created by Mingoo on 2023/04/20.
//

import UIKit
import RxSwift
import RxCocoa

protocol MainUseCaseProtocol {
    
}

final class MainUseCase: MainUseCaseProtocol {
    private let findRoutineDayRepository: FindRoutineDayProtocol
    private let findAllRoutineDayRepository: FindAllRoutineDayProtocol
    private let routineDeleteRepository: RoutineDeleteProtocol
    private let routineGetRepository: RoutineGetProtocol
    private let routineCheckRepository: RoutineCheckProtocol
    private let routineAlarmListRepository: RoutineAlarmListProtocol
    private let withDrawRepository: WithDrawProtocol
    private let appleService: AppleServiceProtocol
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    var appleInfo: PublishRelay<[String:Any]> = PublishRelay()
    
    init(findRoutineDayRepository: FindRoutineDayProtocol,
         findAllRoutineDayRepository: FindAllRoutineDayProtocol,
         routineDeleteRepository: RoutineDeleteProtocol,
         routineGetRepository: RoutineGetProtocol,
         routineCheckRepository: RoutineCheckProtocol,
         routineAlarmListRepository: RoutineAlarmListProtocol,
         withDrawRepository: WithDrawProtocol,
         appleService: AppleServiceProtocol) {
        self.findRoutineDayRepository = findRoutineDayRepository
        self.findAllRoutineDayRepository = findAllRoutineDayRepository
        self.routineDeleteRepository = routineDeleteRepository
        self.routineGetRepository = routineGetRepository
        self.routineCheckRepository = routineCheckRepository
        self.routineAlarmListRepository = routineAlarmListRepository
        self.withDrawRepository = withDrawRepository
        self.appleService = appleService
    }
    
    func findRoutineDayRequest(_ dto: FindRoutineDayDTO) -> Observable<FindRoutineDayModel> {
        return Observable.create { [weak self] observer in
            
            self?.findRoutineDayRepository.requestFindRoutineDay(dto: dto, success: { responseData in
                observer.onNext(responseData)
            }, failure: { error in
                observer.onError(error)
            })
            
            return Disposables.create()
        }
    }
    
    func findAllRoutineDayRequest(_ dto: FindAllRoutineDayDTO) -> Observable<FindAllRoutineDayModel> {
        return Observable.create { [weak self] observer in
            
            self?.findAllRoutineDayRepository.requestFindAllRoutineDay(dto: dto) { responseData in
                observer.onNext(responseData)
            } failure: { error in
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func routineDeleteRequest() -> Observable<RoutineDeleteModel> {
        return Observable.create { [weak self] observer in
            
            self?.routineDeleteRepository.requestRoutineDelete(success: { responseData in
                observer.onNext(responseData)
            }, failure: { error in
                observer.onError(error)
            })
            
            return Disposables.create()
        }
    }
    
    func routineGetRequest() -> Observable<RoutineGetModel> {
        return Observable.create { [weak self] observer in
            
            self?.routineGetRepository.requestRoutineGet(success: { responseData in
                observer.onNext(responseData)
            }, failure: { error in
                observer.onError(error)
            })
            
            return Disposables.create()
        }
    }
    
    func routineCheckRequest(_ dto: RoutineCheckDTO) -> Observable<RoutineCheckModel> {
        return Observable.create { [weak self] observer in
            
            self?.routineCheckRepository.requestRoutineCheck(dto: dto,
                                                             success: { responseData in
                observer.onNext(responseData)
            }, failure: { error in
                observer.onError(error)
            })
            
            return Disposables.create()
        }
    }
    
    func routineAlarmListRequest() -> Observable<RoutineAlarmListModel> {
        return Observable.create { [weak self] observer in
            
            self?.routineAlarmListRepository.requestRoutineAlarmList(success: { responseData in
                observer.onNext(responseData)
            }, failure: { error in
                observer.onError(error)
            })
            
            return Disposables.create()
        }
    }
    
    func withdrawRequest() -> Observable<WithDrawModel> {
        return Observable.create { [weak self] observer in
            
            self?.withDrawRepository.requestWithDraw(success: { responseData in
                observer.onNext(responseData)
            }, failure: { error in
                observer.onError(error)
            })
            
            return Disposables.create()
        }
    }
    
    func appleLoginStart() {
        appleService.requestAppleLogin()
        getAppleInfo()
    }
    
    func getAppleInfo() {
        appleService.observableAppleInfo()
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.appleInfo.accept(value)
            })
            .disposed(by: disposeBag)
    }
}
