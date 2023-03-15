//
//  GoogleService.swift
//  moneysave
//
//  Created by Bluewave on 2023/03/15.
//

import Foundation
import RxSwift
import RxCocoa
import GoogleSignIn
import Firebase
import FirebaseAuth

protocol GoogleServiceProtocol {
    func requestGoogleLogin(_ resenting: UIViewController)
    func observableGoogleInfo() -> Observable<Bool>
}

final class GoogleService: GoogleServiceProtocol {
    var googleInfo: PublishRelay<Bool> = PublishRelay()
    
    func requestGoogleLogin(_ presenting: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            googleInfo.accept(false)
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { [weak self] result, error in
            if let _ = error {
                self?.googleInfo.accept(false)
                return
            }
            
            if let result = result?.user {
                let idToken = result.idToken?.tokenString ?? ""
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: result.accessToken.tokenString)
                
                Auth.auth().signIn(with: credential) { [weak self] result, error in
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
