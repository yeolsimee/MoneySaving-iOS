//
//  AppleService.swift
//  moneysave
//
//  Created by Bluewave on 2023/03/15.
//

import UIKit
import RxSwift
import RxCocoa
import AuthenticationServices

protocol AppleServiceProtocol {
    func requestAppleLogin()
    func observableAppleInfo() -> Observable<[String:Any]>
}

final class AppleService: NSObject, AppleServiceProtocol {
    var loginInstance: ASAuthorizationController?
    var disposeBag: DisposeBag = DisposeBag()
    var appleInfo: PublishRelay<[String:Any]> = PublishRelay()
    
    override init() {
        super.init()
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        loginInstance = ASAuthorizationController(authorizationRequests: [request])
        loginInstance?.delegate = self
        loginInstance?.presentationContextProvider = self
    }
    
    func requestAppleLogin() {
        loginInstance?.performRequests()
    }
    
    func observableAppleInfo() -> Observable<[String:Any]> {
        return appleInfo.asObservable()
    }
}

extension AppleService: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        // 인증 성공
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            var userInfo: [String:Any] = [:]
            userInfo.updateValue(appleIDCredential.user, forKey: "identifier")
            
            if let email = appleIDCredential.email {
                userInfo.updateValue(email, forKey: "email")
            }
            
            if let fName = appleIDCredential.fullName?.familyName {
                userInfo.updateValue(fName, forKey: "fName")
            }
            
            if let gName = appleIDCredential.fullName?.givenName {
                userInfo.updateValue(gName, forKey: "gName")
            }
            
            appleInfo.accept(userInfo)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 인증 에러
        print("apple Login Error : \(error)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return (UIApplication.shared.windows.first?.window)!
    }
}
