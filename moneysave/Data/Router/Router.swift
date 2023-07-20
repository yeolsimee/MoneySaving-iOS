//
//  Router.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/15.
//

import UIKit
import Alamofire


enum Router: URLRequestConvertible {
    // MARK: - Cases
    case login
    case customLogin
    case changeIsNewUser(dto: ChangeIsNewUserDTO)
    case signUp(dto: SignUpRequestDTO)
    case findAllRoutineDay(dto: FindAllRoutineDayDTO)
    case findRoutineDay(dto: FindRoutineDayDTO)
    case categoryList
    case categoryInsert(dto: CategoryInsertDTO)
    case categoryDelete(dto: CategoryDeleteDTO)
    case categoryUpdate(dto: CategoryUpdateDTO)
    case routineCreate(dto: RoutineCreateDTO)
    case routineDelete
    case routineGet
    case routineUpdate(dto: RoutineUpdateDTO)
    case routineCheck(dto: RoutineCheckDTO)
    case withDraw
    case routineAlarmList
    
    // MARK: - Method
    var method: HTTPMethod {
        switch self {
        case .login, .customLogin, .changeIsNewUser, .signUp, .categoryInsert, .categoryDelete, .categoryUpdate, .routineCreate, .routineCheck, .withDraw:
            return .post
            
        case .findAllRoutineDay, .findRoutineDay, .categoryList, .routineGet, .routineAlarmList:
            return .get
            
        case .routineDelete:
            return .delete
            
        case .routineUpdate:
            return .put
        }
    }
    
    // MARK: - Headers
    var headers: HTTPHeaders {
        switch self {
        default:
            return ["Content-Type" : "application/json",
                    "x-auth" : UserInfo.token]
        }
    }
    
    // MARK: - Body
    
    // MARK: - Paths
    var path: String {
        switch self {
        case .login:
            return "api/v1/login"
        case .customLogin:
            return "api/v1/login/custom"
        case .changeIsNewUser:
            return "api/v1/isnewuser/update"
        case .signUp:
            return "api/v1/signup"
        case .findAllRoutineDay:
            return "api/v1/routinedays"
        case .findRoutineDay:
            return "api/v1/routineday"
        case .categoryList:
            return "api/v1/category"
        case .categoryInsert:
            return "api/v1/category/insert"
        case .categoryDelete:
            return "api/v1/category/delete"
        case .categoryUpdate:
            return "api/v1/category/update"
        case .routineCreate, .routineAlarmList:
            return "api/v1/routine"
        case .routineDelete, .routineGet, .routineUpdate:
            return "api/v1/routine/\(UserInfo.routineId)"
        case .routineCheck:
            return "api/v1/routinecheck"
        case .withDraw:
            return "api/v1/withdraw"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .login, .customLogin,.categoryList, .routineDelete, .routineGet, .withDraw, .routineAlarmList:
            return nil
            
        case .changeIsNewUser(let dto):
            return dto.toDictionary
            
        case .signUp(let dto):
            return dto.toDictionary
            
        case .findAllRoutineDay(let dto):
            return dto.toDictionary
            
        case .findRoutineDay(let dto):
            return dto.toDictionary
            
        case .categoryInsert(let dto):
            return dto.toDictionary
            
        case .categoryDelete(let dto):
            return dto.toDictionary
            
        case .categoryUpdate(let dto):
            return dto.toDictionary
            
        case .routineCreate(let dto):
            return dto.toDictionary
        
        case .routineUpdate(let dto):
            return dto.toDictionary
            
        case .routineCheck(let dto):
            return dto.toDictionary
        }
    }
    
    // MARK: - Encoding
    var encoding: ParameterEncoding {
        switch self {
        case .changeIsNewUser, .categoryInsert, .categoryDelete, .categoryUpdate, .routineCreate, .routineUpdate, .routineCheck:
            return JSONEncoding.default
            
        default:
            return URLEncoding.default
        }
    }
    
    // MARK: - URL Request
    func asURLRequest() throws -> URLRequest {
        var url: URL!
        if #available(iOS 16.0, *) {
            url = NetworkConstatns.baseURL.appending(path: path)
        } else {
            url = NetworkConstatns.baseURL.appendingPathExtension(path)
        }
        
        var urlRequest = URLRequest(url: url)
        
        // HTTP Method
        urlRequest.method = method
        
        urlRequest.headers = headers
        
        if let parameters = parameters {
            return try encoding.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
