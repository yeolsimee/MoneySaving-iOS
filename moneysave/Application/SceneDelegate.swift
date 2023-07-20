//
//  SceneDelegate.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/15.
//

import UIKit
import KakaoSDKAuth
import RxKakaoSDKAuth
import NaverThirdPartyLogin
import GoogleSignIn
import Firebase
import FirebaseAuth
import FirebaseDynamicLinks
import RxSwift
import RxCocoa

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController

        let coordinator = AppCoordinator(window: window!)
        coordinator.start()
        
        // DynamicLinks Set
        if let userActivity = connectionOptions.userActivities.first {
            self.scene(windowScene, continue: userActivity)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        for context in URLContexts {
            let url = context.url
            
            if url.scheme == kServiceAppUrlScheme {
                NaverThirdPartyLoginConnection.getSharedInstance().receiveAccessToken(url)
            } else if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            } else if url.scheme!.contains("com.googleusercontent.apps") {
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}

// MARK: - DynamicLink Set
extension SceneDelegate {
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let incomingURL = userActivity.webpageURL {
            let _ = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { link, error in
                if let url = link?.url {
                    print("1928 url : \(url)")
                    /*
                     https://moneysaving-3eaf6.firebaseapp.com/__/auth/action?apiKey=AIzaSyAl8vggILDIsNH_sRpbXxs8dxFmcktgEK0&mode=signIn&oobCode=SAbaTdE-1MsdeWzqsQO7P26DzY69qyGMdoX-LseXhBQAAAGHDB94XQ&continueUrl=https://moneysaving.page.link/Tbeh?email%3Dkmui123@naver.com&lang=en
                     */
                    
                    let email = url.absoluteString.removingPercentEncoding?.slice(from: "email=", to: "&") ?? ""
                    print("email : \(email)")
                    
                    Auth.auth().signIn(withEmail: email, link: url.absoluteString) { result, error in
                        if let error = error {
                            print("error : \(error.localizedDescription)")
                            return
                        }
                        
                        result?.user.getIDTokenResult(forcingRefresh: false) { [weak self] token, error in
                            print("getToken : \(token?.token)")
                            var userInfo: [AnyHashable:Any] = [:]
                            userInfo.updateValue(token?.token ?? "", forKey: "emailToken")
                            NotificationCenter.default.post(name: .init("emailToken"), object: nil, userInfo: userInfo)
                        }
                    }
                }
            }
        }
    }
}

