//
//  NaverService.swift
//  moneysave
//
//  Created by Bluewave on 2023/03/15.
//

import UIKit
import RxSwift
import RxCocoa
import NaverThirdPartyLogin
import Alamofire

protocol NaverServiceProtocol {
    func requestNaverLogin()
    func observableNaverInfo() -> Observable<NaverUserInfo>
}

final class NaverService: NSObject, NaverServiceProtocol {
    var naverManager: NaverThirdPartyLoginConnection?
    var disposeBag: DisposeBag = DisposeBag()
    var naverInfo: PublishRelay<NaverUserInfo> = PublishRelay()
    
    override init() {
        super.init()
        
        naverManager = NaverThirdPartyLoginConnection.getSharedInstance()
        naverManager?.delegate = self
    }
    
    func requestNaverLogin() {
        naverManager?.resetToken()
        naverManager?.requestThirdPartyLogin()
    }
    
    func observableNaverInfo() -> Observable<NaverUserInfo> {
        return naverInfo.asObservable()
    }
    
    private func getNaverInfo() {
        if let accessToken = naverManager?.isValidAccessTokenExpireTimeNow(), accessToken {
            guard let tokenType = naverManager?.tokenType,
                  let accessToken = naverManager?.accessToken else { return }
            
            let url = URL(string: "https://openapi.naver.com/v1/nid/me")!
            let authorization = "\(tokenType) \(accessToken)"
            
            
            
            AF.request(url,
                       method: .get,
                       encoding: JSONEncoding.default,
                       headers: ["Authorization" : authorization]).responseJSON { [weak self] response in
                guard let result = response.value as? [String:Any],
                      let object = result["response"] as? [String:Any],
                      let code = result["resultcode"] as? String else { return }
                
                var resultValue = object
                resultValue.updateValue(code, forKey: "resultcode")
                
                do {
                    let jsonData: Data = try JSONSerialization.data(withJSONObject: resultValue, options: .sortedKeys)
                    let model = try JSONDecoder().decode(NaverUserInfo.self, from: jsonData)
                    
                    self?.naverInfo.accept(model)
                } catch {
                    
                }
            }
        }
    }
}

extension NaverService: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        getNaverInfo()
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        // 접속토큰갱신
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        // 로그아웃(토큰삭제)
        naverManager?.requestDeleteToken()
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("naver Error : \(error.localizedDescription)")
    }
}
