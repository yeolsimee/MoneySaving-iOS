//
//  GoogleService.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/15.
//

import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth
import GoogleSignIn

protocol GoogleServiceProtocol {
    func requestGoogleLogin(_ presenting: UIViewController)
    func observableGoogleInfo() -> Observable<Bool>
}

final class GoogleService: NSObject, GoogleServiceProtocol {
    let disposeBag: DisposeBag = DisposeBag()
    var googleInfo: PublishRelay<Bool> = PublishRelay()
    
    var presentingView: UIViewController?
    
    func requestGoogleLogin(_ presenting: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { [weak self] result, error in
            if let _ = error {
                self?.googleInfo.accept(false)
                return
            }
            
            if let user = result?.user, let token = user.idToken?.tokenString {
                let credential = GoogleAuthProvider.credential(withIDToken: token, accessToken: user.accessToken.tokenString)
                
                Auth.auth().signIn(with: credential) { result, error in
                    
                    if let _ = error {
                        self?.googleInfo.accept(false)
                        return
                    }
                    
                    if let _ = result {
                        self?.googleInfo.accept(true)
                    }
                }
                
            }
        }
    }
    
    func observableGoogleInfo() -> Observable<Bool> {
        return googleInfo.asObservable()
    }
    
}

