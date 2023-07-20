//
//  LoginError.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/04.
//

import Foundation

enum LoginError: Error {
    case successError
    case apiError
    
    var description: String {
        switch self {
        case .successError:
            return I18NStrings.Login.error_Success
        case .apiError:
            return I18NStrings.Login.error_API
        }
    }
}
