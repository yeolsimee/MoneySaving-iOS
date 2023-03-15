//
//  KakaoUserInfo.swift
//  moneysave
//
//  Created by Bluewave on 2023/03/15.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import RxKakaoSDKAuth
import RxKakaoSDKUser
import RxKakaoSDKCommon

struct KakaoUserInfo {
    let id: Int64
    let nickname: String
    let token: OAuthToken
}
