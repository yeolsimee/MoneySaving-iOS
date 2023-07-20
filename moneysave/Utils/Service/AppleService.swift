//
//  AppleService.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/15.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth
import CryptoKit
import AuthenticationServices


protocol AppleServiceProtocol {
    func requestAppleLogin()
    func observableAppleInfo() -> Observable<[String:Any]>
}

final class AppleService: NSObject, AppleServiceProtocol {
    var loginInstance: ASAuthorizationController?
    var disposeBag: DisposeBag = DisposeBag()
    var appleInfo: PublishRelay<[String:Any]> = PublishRelay()
    
    fileprivate var currentNonce: String?
    
    override init() {
        super.init()
        
        let nonce = randomNonceString()
        currentNonce = nonce
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
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
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if length == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let input = Data(input.utf8)
        let hashed = SHA256.hash(data: input)
        let hashString = hashed.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

extension AppleService: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        // 인증 성공
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            var userInfo: [String:Any] = [:]
            userInfo.updateValue(appleIDCredential.user, forKey: "identifier")
            print("2222 identifier : \(appleIDCredential.user)")
            if let email = appleIDCredential.email {
                userInfo.updateValue(email, forKey: "email")
            }
            
            if let fName = appleIDCredential.fullName?.familyName {
                userInfo.updateValue(fName, forKey: "fName")
            }
            
            if let gName = appleIDCredential.fullName?.givenName {
                userInfo.updateValue(gName, forKey: "gName")
            }
            
            guard let nonce = currentNonce else {
                return
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let _ = error {
                    print("이거 탐?")
                    return
                }
                
                authResult!.user.getIDToken() { [weak self] token, error in
                    userInfo.updateValue(token ?? "", forKey: "idToken")
                    print("2222 token : \(token)")
                    self?.appleInfo.accept(userInfo)
                }
                
                let email = Auth.auth().currentUser?.email
            }
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
